class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.16.tgz"
  sha256 "333c0b821a896ce2ebf3cf529abb63ba430a5fd07cfd243c85e293248260d473"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48bdf3e94d2a77d2a87dbf98a9d1c6f3d110e76749fcd8c86e0c864ec94b986e"
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