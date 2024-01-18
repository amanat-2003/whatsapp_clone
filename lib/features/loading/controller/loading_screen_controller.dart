typedef CloseLoadingScreenFunctionType = bool Function();
typedef UpdateLoadingScreenFunctionType = bool Function(String);

class LoadingScreenController {
  final CloseLoadingScreenFunctionType close;
  final UpdateLoadingScreenFunctionType update;

  LoadingScreenController({
    required this.close,
    required this.update,
  });
}
