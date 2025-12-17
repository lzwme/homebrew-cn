class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.53.5.tgz"
  sha256 "52da36357a066a554f6bf6b0691abd9368f9a1d4771271fb96273e08777e114c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4adf34814d53f14c1204ed1b56f7e7f044893493cec44657f0023399f9ac571"
    sha256 cellar: :any,                 arm64_sequoia: "c5b877d94ffc801a2215431546dc55b916bc22ff28d48552f96971866cdb0952"
    sha256 cellar: :any,                 arm64_sonoma:  "c5b877d94ffc801a2215431546dc55b916bc22ff28d48552f96971866cdb0952"
    sha256 cellar: :any,                 sonoma:        "bf28823f33eedf9383ff414f56b55ae0c16774d039beb7d2c35d880c14ce9f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b280b33278592158a0d8cf4d57030c01abbc68b8c11e406b57144253ba8c0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e570820fd35b17867dbfc95432d3467fcb097cdc888bc060c39a6c6607d8e9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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