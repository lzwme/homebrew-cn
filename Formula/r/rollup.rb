class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.29.2.tgz"
  sha256 "5117d03c4cf7e0004f550bdde66480a4ad51ff34e0723a7f6ee1c14d61f2c992"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "10b072db3c878a5c907f393477c5264be10cff5d38139aacffe32c15b89e923d"
    sha256 cellar: :any,                 arm64_sonoma:  "10b072db3c878a5c907f393477c5264be10cff5d38139aacffe32c15b89e923d"
    sha256 cellar: :any,                 arm64_ventura: "10b072db3c878a5c907f393477c5264be10cff5d38139aacffe32c15b89e923d"
    sha256 cellar: :any,                 sonoma:        "e41594f52c48c30871be6ccb5896599753d9ae788d33aeec98a38fefdf03d180"
    sha256 cellar: :any,                 ventura:       "e41594f52c48c30871be6ccb5896599753d9ae788d33aeec98a38fefdf03d180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e66bfec67ec2c16569571ced1deef8ba631235e25dea40b72f8d01e4c63557"
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