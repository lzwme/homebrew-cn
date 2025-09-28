class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.82.4.tgz"
  sha256 "f5f5852200cde799714aa0d831b3ef74d4031dfe2f4fc13a11732efa2f8327df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3aef08803a9b977604f9698d01ee7a06d3f60e15b158a270824e0c6848561ab4"
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