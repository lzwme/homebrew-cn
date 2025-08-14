class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.15.tgz"
  sha256 "04747f75ea1f10d2fc86069ce09096e89dcb44b4af62568210ea58b455a372c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a3916efac48260a70c37859ca5ad0e338250450a78fcd54f6e03a26ff0fb561"
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