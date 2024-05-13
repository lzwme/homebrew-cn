require "language/node"

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.0.tgz"
  sha256 "82468e44d6cf4d50c6f61b46e2a1651ef0779851df722a7d79e265ead591ba59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb7082b1948744e571d66053b6111013c040d86e18fbd3c1e7149a79eabf5b11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0ae27f6df4cdecbdbc62af486236da733f6da42269eff9e04ae5f42c9d3bbd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a5ad4c6a2aef1a573cbe33ff624bc2522f90374655ff27ec3c5054dc744c762"
    sha256 cellar: :any_skip_relocation, sonoma:         "61994b7d88cec5e8dc8cb3f94c0ac523ce0f3942089ca34eace21b30c2fe58bb"
    sha256 cellar: :any_skip_relocation, ventura:        "346e1781e4223f5d745e45f57a2f07feb95cac57f048b0c52c7ccebfaf927d4c"
    sha256 cellar: :any_skip_relocation, monterey:       "511467d3fb7e645432b4df50b267cc41f9fcf057cd9f3f287e3f62342379ae90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19887a2436747b28ce75d43cce8e9b12b5646ff384efdf1c723648611a4fbd54"
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