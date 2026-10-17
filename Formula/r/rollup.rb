class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.64.7.tgz"
  sha256 "1a148eee0559cc608be36379055a764585a2c205a5f6b422b2080ffe5ef0d52d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "508b95496a88c8c79ea3db2ccd035373a55bf033facd6751cc8375c3094b6c25"
    sha256 cellar: :any,                 arm64_tahoe:       "508b95496a88c8c79ea3db2ccd035373a55bf033facd6751cc8375c3094b6c25"
    sha256 cellar: :any,                 arm64_sequoia:     "508b95496a88c8c79ea3db2ccd035373a55bf033facd6751cc8375c3094b6c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae02d34deabb0a1b928215d4c0362ea634c2f22d27abb79e921c2a3e17098384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "86644b812ac1b18307e14f350fb0206c25a08d9eb2a91dec394cdeb7de4f39c7"
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