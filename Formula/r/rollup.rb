class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.47.1.tgz"
  sha256 "3ec73c37161ee7185d10582dad6c84e3f2b2ab11299e876db39cbcac98b051a3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "890ce721b0bba8450e4faa0b3f40e2dc38a4b282dcc0693d5808451e39037b54"
    sha256 cellar: :any,                 arm64_sonoma:  "890ce721b0bba8450e4faa0b3f40e2dc38a4b282dcc0693d5808451e39037b54"
    sha256 cellar: :any,                 arm64_ventura: "890ce721b0bba8450e4faa0b3f40e2dc38a4b282dcc0693d5808451e39037b54"
    sha256 cellar: :any,                 sonoma:        "990daa73abd96f5f4c1e11897946699e5d4d35e3effd5e7cb6b0e9a1d22c8b68"
    sha256 cellar: :any,                 ventura:       "990daa73abd96f5f4c1e11897946699e5d4d35e3effd5e7cb6b0e9a1d22c8b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68d42e770cf7c2940d8fb0c4bf68802575c60a6c40eee1a4bcbef94c580dc7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46feba82da9999a962169ddfda48377625946621bdcd1a291cf30b2abc6ec2ed"
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