package;

import monsoon.middleware.Body;
import monsoon.middleware.Static;
import monsoon.middleware.Compression;

using Monsoon;

class Controller {
	public function new() {}
	
	public function createRoutes(router: Router) {
		router.get('/', function(req: Request, res: Response) res.json({route: 'controller_index'}));
		router.get('/path', function(req: Request, res: Response) res.json({route: 'controller_path'}));
	}
}

class Run {

	inline static var target = #if cpp 'cpp' #elseif neko 'neko' #elseif nodejs 'nodejs' #elseif java 'java' #elseif php 'php' #else '' #end;

	public static function main() {
		var app = new Monsoon();

		app.use('/public', Static.serve('public'));

		app.route('/', function(req: Request, res: Response) res.send('ok'));

		app.get([
			'/controller' => new Controller(),
			'/arg/:arg' => testArgumentInt,
			'/arg/:arg' => testArgumentString,
			'/cookie' => function(req: Request, res: Response) {
				res.cookie('name', 'value').send(req.cookies.get('name'));
			},
			'/header' => function(req: Request, res: Response) res.set('test', req.get('test')).send('ok')
		]);

		app.post([
			'/post' => testMiddleware
		]);
		
		app.use(new Compression());
		app.route('/gzip', function(req, res) res.send('zipped'));

		var port = #if (sys || nodejs) Sys.args().length > 0 ? Std.parseInt(Sys.args()[0]) : 80 #else 80 #end;
		app.listen(port);

		#if (embed || nodejs)
		Sys.print(target+' listening on '+port);
		#end
	}

	static function testArgumentInt(req: Request<{arg: Int}>, res: Response)
		res.json({arg: req.params.arg});

	static function testArgumentString(req: Request<{arg: String}>, res: Response)
		res.json({arg: req.params.arg});

	static function testMiddleware(req: Request, res: Response, body: Body)
		res.json({body: Std.string(body)});
}
