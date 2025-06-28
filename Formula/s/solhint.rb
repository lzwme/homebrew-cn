class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.2.0.tgz"
  sha256 "69e32ff3f2cfc736f99f2296f347a330c1fcb0e14372b1d88a67386a4c3012c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2987fd70977d03e84b35845ae46281790b938238b5a5825576921d85c7c4e20c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2987fd70977d03e84b35845ae46281790b938238b5a5825576921d85c7c4e20c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2987fd70977d03e84b35845ae46281790b938238b5a5825576921d85c7c4e20c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94d352d0814961a6b566747f53a9b1f570729ccece05242bd6708a24d943a27e"
    sha256 cellar: :any_skip_relocation, ventura:       "94d352d0814961a6b566747f53a9b1f570729ccece05242bd6708a24d943a27e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2987fd70977d03e84b35845ae46281790b938238b5a5825576921d85c7c4e20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2987fd70977d03e84b35845ae46281790b938238b5a5825576921d85c7c4e20c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~JSON
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    JSON

    (testpath/"test.sol").write <<~SOLIDITY
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    SOLIDITY
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end