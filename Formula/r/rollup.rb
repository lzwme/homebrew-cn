class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.60.4.tgz"
  sha256 "1c1df63c15b541841069df819e813ac80ee6a78785dff7cf0f7c27261b78aac4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5054fa6f871ed3fbb0a5fa371e16829944de394b578e5d678e98f3e87768af6f"
    sha256 cellar: :any,                 arm64_sequoia: "82f4fe05b269e4eea9b95d367e7882adf71ed1898b57362dc0c5e47f41e23403"
    sha256 cellar: :any,                 arm64_sonoma:  "82f4fe05b269e4eea9b95d367e7882adf71ed1898b57362dc0c5e47f41e23403"
    sha256 cellar: :any,                 sonoma:        "727505bd16c59e5429ff2e4736949d1a16e74db8a495d2980fffe69145e22d3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34c8aa0d3fcea50ac3c523e214d9e3c5968b833642d2c52ad68bb252d88a9afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b8b1c1836887b85717b325eaf62908b427fcb1f83452a450970d11726d6501"
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