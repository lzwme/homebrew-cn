require "language/node"

class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-5.0.2.tgz"
  sha256 "072a0704218fc9c1c13bf86e3074ab3cc79fa4b8586931ec2acd4f510c53865c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53a0bd26d8ca86865905f2eb9648385783d451f66bd8cc5f0c90a14de3ff88aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53a0bd26d8ca86865905f2eb9648385783d451f66bd8cc5f0c90a14de3ff88aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a0bd26d8ca86865905f2eb9648385783d451f66bd8cc5f0c90a14de3ff88aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5a3700968c53f71b1b02d6cae9363c4584856a6814caea3858a3ec568cfa3d5"
    sha256 cellar: :any_skip_relocation, ventura:        "c5a3700968c53f71b1b02d6cae9363c4584856a6814caea3858a3ec568cfa3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "7d054a8aaf63e6bc74016009d8280b1f293b5dfda8c5c6feb412d9159f055150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c43618fbb4398aa69d5b0d8b15367f5413fccc921f4d99da8eb2080e6fce76"
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