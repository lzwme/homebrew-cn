class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.85.1.tgz"
  sha256 "da57977b2c1505905ecc6f4ae4f5083b768687df3ecad0fb0f3cf2d09ed5ed17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b9a9182f27f9ea134a4b672dc4e12a4e834d1fa0d8d052992268a5ea0f08de9"
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