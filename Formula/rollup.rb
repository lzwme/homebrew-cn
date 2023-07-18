require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.26.3.tgz"
  sha256 "aa77587d193a103433e78040e30fcf9043bd6158c66d89b3060a0e504b7ee6ec"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9f99b1b2470fbef8ca198869ff32f0700c2708728eaea27b29fefb7f4dbdb1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9f99b1b2470fbef8ca198869ff32f0700c2708728eaea27b29fefb7f4dbdb1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9f99b1b2470fbef8ca198869ff32f0700c2708728eaea27b29fefb7f4dbdb1a"
    sha256 cellar: :any_skip_relocation, ventura:        "437a6faaca95edcfe6a6d74d7790ccc4d6644771ba53fc469bfe00639e33b184"
    sha256 cellar: :any_skip_relocation, monterey:       "437a6faaca95edcfe6a6d74d7790ccc4d6644771ba53fc469bfe00639e33b184"
    sha256 cellar: :any_skip_relocation, big_sur:        "437a6faaca95edcfe6a6d74d7790ccc4d6644771ba53fc469bfe00639e33b184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d43feb023cd0dc9dc0d2392a2e8913d9affe149b1a45d17c3e37d2cccb0a853"
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