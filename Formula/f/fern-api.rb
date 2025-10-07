class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.85.0.tgz"
  sha256 "424706fad23b2f71dfcfac35719bf3732cd5e4791b3a515cecbcaa003a1c8a21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8df5548bea502143bb2250a045b032f3bb851c12f039fce1fe9de1da4bd3c90"
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