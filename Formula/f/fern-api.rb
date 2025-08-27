class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.26.tgz"
  sha256 "574412e7ad3cc53ab172e946da5394e5f3393aa5fcff062e6da9e5a166d52866"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35072f0be34a22d938d73b738d02ebe1a787a214166a99e3257997bdfb475755"
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