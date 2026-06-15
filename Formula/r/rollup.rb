class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.62.0.tgz"
  sha256 "24439e7de4819544abc45d37aeed1d4acbbc37aa2fc60c776039a301de93abc2"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77d41d14693053eaa699e85beb5bee577f50f3afcace107ffa0bdb7cb930ba00"
    sha256 cellar: :any,                 arm64_sequoia: "e6763a46d90604fd16add24a90179dfe27bd869fa47bc84b743c5381289e5bea"
    sha256 cellar: :any,                 arm64_sonoma:  "e6763a46d90604fd16add24a90179dfe27bd869fa47bc84b743c5381289e5bea"
    sha256 cellar: :any,                 sonoma:        "505cf5fa2773c09f5c31e8400c1bf8709e7c2abdcafcf8e76ab5c5102799faf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "814b136a6b194199e78bbb7eec587ae6ac7111432a982510eb3d3370d0351b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93b120bb5737143d754ebb0b00d57a315bb4d85186d0e935bd21bfefd4fda36d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end