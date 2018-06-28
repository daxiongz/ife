/*var foo = (function CoolModules(id) {
	function change () {
		publicAPI.identify = identify2;
	}

	function identify1() {
		console.log(id);
	}

	function identify2() {
		console.log(id.toUpperCase())
	}

	var publicAPI = {
		change: change,
		identify: identify1
	};

	return publicAPI;
})( "foo module" );

foo.identify();
foo.change();
foo.identify();*/
var MyModules = (function Manager() {
  var modules = {};

  function define(name, deps, impl) {
    for (var i = 0; i < deps.length; i++) {
      deps[i] = modules[deps[i]];
      // console.log("deps:" + deps[i] + " mo:" + modules[deps[i]])
      console.log(deps[i])
      console.log(modules[deps[i]])
    }

    modules[name] = impl.apply(impl, deps);
    console.log(deps)
    console.log(impl)
    console.log(modules[name]);
  }

  function get(name) {
    return modules[name];
  }
  console.log(modules)
  return {
    define: define,
    get: get,
    module: modules
  };
})();

MyModules.define("bar", [], function() {
  function hello(who) {
    return "Let me introduce: " + who;
  }
  return {
    hello: hello
  };
});
MyModules.define("foo", ["bar"], function(bar) {
  var hungry = "hippo";

  function awesome() {
    console.log(bar.hello(hungry).toUpperCase());
  }
  return {
    awesome: awesome
  };
});