require "language/node"

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-4.0.0.tgz"
  sha256 "5e1b1c7d22f43a399a172591393c09d34beaf69205f8b323384bc4ee5274de35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "741495caac816a6784c3732b4308147015ebd39918a64f89a3d85b3348f3605a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "741495caac816a6784c3732b4308147015ebd39918a64f89a3d85b3348f3605a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741495caac816a6784c3732b4308147015ebd39918a64f89a3d85b3348f3605a"
    sha256 cellar: :any_skip_relocation, sonoma:         "965b360eb9ce92b902f79297809f05343d889d4c1601371645761e7491f1c88c"
    sha256 cellar: :any_skip_relocation, ventura:        "965b360eb9ce92b902f79297809f05343d889d4c1601371645761e7491f1c88c"
    sha256 cellar: :any_skip_relocation, monterey:       "965b360eb9ce92b902f79297809f05343d889d4c1601371645761e7491f1c88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "741495caac816a6784c3732b4308147015ebd39918a64f89a3d85b3348f3605a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~EOS
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    EOS

    (testpath/"test.sol").write <<~EOS
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    EOS
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end