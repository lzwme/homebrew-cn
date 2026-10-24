class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.65.0.tgz"
  sha256 "3b43d80d36cd7ec993c7b17ea9797988717f885a8659987daacf5cdd800b7a7c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5298df46ca3668c19640bf9800c9f2ba8e67aa0c532ea233979587e0b829ba4a"
    sha256 cellar: :any,                 arm64_tahoe:       "5298df46ca3668c19640bf9800c9f2ba8e67aa0c532ea233979587e0b829ba4a"
    sha256 cellar: :any,                 arm64_sequoia:     "5298df46ca3668c19640bf9800c9f2ba8e67aa0c532ea233979587e0b829ba4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a37be7689f6429c3c75798edece2a4526aa3f3ff1cbec68881374eaf8c18f6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1ddc605aec7313a5f7a2a1fa3def652848efc6b542570f457b155718c6c7363d"
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