class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.74.0.tgz"
  sha256 "6e82d4c9917e6c594fec825b65e7cd02a5bf8db3465daeb0f35f7a38e340b0fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "729a1593bb230ceeb6ec5caa78dc08c1a81544859e3eb9bfdab5c96420fd128d"
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