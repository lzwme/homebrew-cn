class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.29.tgz"
  sha256 "ae870f977d440764078662da3dbc01185c8e7711aa89aa6549cd4298bbca38d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a73f146eb04062190c12e762b6a8f6d05f5c2c4595164db2c52bb256ec6f1bd"
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