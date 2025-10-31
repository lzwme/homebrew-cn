class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.101.2.tgz"
  sha256 "8baa1279d09eabfbfb522da0f8c10be8d902b0ae830f0617911aa94895a7b466"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d45a9026ced86ef8d64657ac6dd4e2fe2c14c876c2d0324b8585529844de8962"
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