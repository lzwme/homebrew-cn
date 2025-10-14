class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.89.0.tgz"
  sha256 "2b273d42fe0b4dea54ef7c6004904b0847cf32eb3364b92291cbd6c21a6016f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c831c810e4125dab4c0fd814123608c97ddb2c410502febffc0d34a712f7ed89"
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