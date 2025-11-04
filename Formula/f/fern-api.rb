class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.107.1.tgz"
  sha256 "ce48104fe59f30a71dc848a231790e33b146ee8ee23fdf877cc409fabaa91b2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "178d96cc77c084e341f6852003f55f524280e0d38b6d8a6f305ab3b7713d98a8"
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