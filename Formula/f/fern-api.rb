class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.109.1.tgz"
  sha256 "e6aa660fb58daf9ca365d34ee3b22e4cfa42ea8eca22e65fab2d7274feb41921"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f7048a88c439bc13aadbd7b9f95be0f3dcbfada54e4be092877a75e013ee229"
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