import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertaladsod/application/screens/store/view_page/bloc/store_view_bloc.dart';
import 'package:fluttertaladsod/domain/auth/i_auth_facade.dart';
import 'package:fluttertaladsod/domain/message/i_message_repository.dart';
import 'package:fluttertaladsod/domain/message/message.dart';
import 'package:fluttertaladsod/domain/message/message_failure.dart';
import 'package:get/get.dart';
import 'input_bar_state.dart';

class InputBarBloc extends GetxController {
  final IMessageRepository _iChatRepository = Get.find<IMessageRepository>();
  final IAuthFacade _iAuthFacade = Get.find<IAuthFacade>();
  final StoreViewBloc _storeViewBloc = Get.find<StoreViewBloc>();

  final textController = TextEditingController();
  InputBarState state = InputBarState.inital();

  Future<void> uploadChat() async {
    Either<MessageFailure, Unit> failureOrSuccess;
    final storeId = _storeViewBloc.store.id;

    if (state.chat.failureOption.isNone()) {
      textController.text = '';
      state = state.copyWith(
        isUploading: true,
        uploadingChat: some(state.chat),
        uploadSuccessOrFailureOption: none(),
        chat: MessageDomain.created(),
      );

      final userOrF = await _iAuthFacade.getSignedInUser();
      final user = userOrF.getOrElse(() => throw 'User unauthenticated');

      failureOrSuccess = await _iChatRepository.uploadMessage(
        storeId: storeId,
        chat: state.uploadingChat
            .getOrElse(
              () => null,
            )
            .copyWith(
              senderId: user.id,
              senderName: user.displayName,
              senderAvatarUrl: user.photoUrl,
            ),
      );

      state = state.copyWith(
        isUploading: false,
        uploadingChat: none(),
        uploadSuccessOrFailureOption: some(failureOrSuccess),
      );
    } else {
      state = state.copyWith(
        uploadingChat: none(),
        isUploading: false,
        uploadSuccessOrFailureOption: optionOf(failureOrSuccess),
      );
    }
  }

  Future<void> bodyChanged(String value) async {
    state = state.copyWith(
      chat: state.chat.copyWith(
        body: value,
      ),
      uploadSuccessOrFailureOption: none(),
    );
  }

  @override
  void onClose() {
    textController.dispose();
    state = null;
    super.onClose();
  }
}
