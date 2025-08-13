class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.13.tgz"
  sha256 "09faefde5a8d450ecfbeec23e44a821384b6b52dd19bacfb1aa2237ab556efd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8757c7e8e0db2733cf7b0668a622c66503cd6b4c6421d4e726f99bf4687fe42f"
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