require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.26.0.tgz"
  sha256 "45b8580054a159ede39b474046bf5e40c2b91c9532ebc1bfa897e1aea372f3b6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb30cb25a9ddf4dc49bda5d31e8b7a2d39473d03a1667c0cb6d3d0ecd6c8072a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb30cb25a9ddf4dc49bda5d31e8b7a2d39473d03a1667c0cb6d3d0ecd6c8072a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb30cb25a9ddf4dc49bda5d31e8b7a2d39473d03a1667c0cb6d3d0ecd6c8072a"
    sha256 cellar: :any_skip_relocation, ventura:        "9e7ea844ecc2720dc3243b89640de852e5b76294233bfa252a7eabdfe2180d75"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7ea844ecc2720dc3243b89640de852e5b76294233bfa252a7eabdfe2180d75"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e7ea844ecc2720dc3243b89640de852e5b76294233bfa252a7eabdfe2180d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93ff8dfffa2f076abdf83be054c4b606cc08b994a09c0d6a1c4ebf8f6e61182"
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