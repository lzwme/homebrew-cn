class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.46.tgz"
  sha256 "a0759041bf74dfad7dd4154b3c9c04c3a0c67375af7451a778b3fe924b0dda9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d852178914af1b06988bdd719cbacc5763d3bb9fbe770c74762e0213db5d67c"
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