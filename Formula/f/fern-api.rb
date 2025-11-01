class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.102.1.tgz"
  sha256 "95c2dd326610bf0b1c96395d30b687f382d1a9da8a29b9a10f052116ad8582d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ccdc42c48f7e8ad130f2f2c430e051b02377bbc3c4bd2a556157790677060fb"
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