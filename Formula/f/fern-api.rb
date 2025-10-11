class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.88.2.tgz"
  sha256 "d3fb2358f96e2d19c219a91a1019eaad9f1e93f6011860c3cfcfb09b48e2f9ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d755be04957a2d66f165ca930119d2047086aaeade19fdb41211e90692d4d048"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end