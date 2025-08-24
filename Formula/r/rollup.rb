class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.48.0.tgz"
  sha256 "836a7a1bde6722726e2afdb87cb78e086acddea3ea048b1a1ea573d52b3ddbab"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2274415a01859893b3d87ee78f6dfca7b83624ea0497cea992181953caaff2f"
    sha256 cellar: :any,                 arm64_sonoma:  "c2274415a01859893b3d87ee78f6dfca7b83624ea0497cea992181953caaff2f"
    sha256 cellar: :any,                 arm64_ventura: "c2274415a01859893b3d87ee78f6dfca7b83624ea0497cea992181953caaff2f"
    sha256 cellar: :any,                 sonoma:        "28f0b3a23ad237ebe979cf6e2430a8929b3c62caa468c74ccda0ad2619f583d1"
    sha256 cellar: :any,                 ventura:       "28f0b3a23ad237ebe979cf6e2430a8929b3c62caa468c74ccda0ad2619f583d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682d7a3a2eb24e80a7c2ae50d6549c59e0a273a0d24730ab1b39953f8ca0ab0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe7b995e77d46633ac5875245ed8be06a5a7a814c9a8cc1ba0195ba58203d99d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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