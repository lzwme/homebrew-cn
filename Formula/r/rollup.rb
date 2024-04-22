require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.16.1.tgz"
  sha256 "413479ae6d0fa4b10b960adbe480347a292131f2d6022877f1582486d5ee744c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8136e13025cbe7302178f7d2b2809cc5f9c8bd022cec98d2bcd0972add056574"
    sha256 cellar: :any,                 arm64_ventura:  "8136e13025cbe7302178f7d2b2809cc5f9c8bd022cec98d2bcd0972add056574"
    sha256 cellar: :any,                 arm64_monterey: "8136e13025cbe7302178f7d2b2809cc5f9c8bd022cec98d2bcd0972add056574"
    sha256 cellar: :any,                 sonoma:         "46cfe78019608e9667ce6108ac2fb6cf25a4535a6cd0746dcf3d3f55808c65e8"
    sha256 cellar: :any,                 ventura:        "46cfe78019608e9667ce6108ac2fb6cf25a4535a6cd0746dcf3d3f55808c65e8"
    sha256 cellar: :any,                 monterey:       "46cfe78019608e9667ce6108ac2fb6cf25a4535a6cd0746dcf3d3f55808c65e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240da0a32f220d8e54e70456b114159fc38ba5918ec8237554a317abc4e039a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end