package;


typedef ContainerMode = monsoon.App.ContainerMode;
typedef Response = monsoon.Response;
typedef App = monsoon.App;
typedef Router<P> = monsoon.Router<P>;
typedef RouteHelper = monsoon.macro.RouteHelper;
typedef AppHelper = monsoon.macro.RouteHelper.AppHelper;
typedef Method = monsoon.PathMatcher.MethodPath;

@:genericBuild(monsoon.macro.RequestBuilder.buildGeneric())
class Request<Rest> {}