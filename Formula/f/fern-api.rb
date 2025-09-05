class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.70.4.tgz"
  sha256 "63f4dc1e6167a1236fd7af2a514c88c206e547282980035dc3700c5b7b1aaeca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "654ab90b2461c5f656572f2f30f769c1a0d272cec1dfedc4ab4fc92ebfbd9838"
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