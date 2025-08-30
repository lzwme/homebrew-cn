class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.31.tgz"
  sha256 "3a1e5fca5573b37dc0cc7948b7e6b79c69c18af761152092decc5a0617b3ef16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c1f0e78eab03a6dbc94123c534670f5b2b06291917992c6a077c799ec030971"
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