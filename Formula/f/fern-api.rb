class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.105.0.tgz"
  sha256 "b5a5a45d4bbcde4323debb97d6a37f96a1d9fac0ff6c2050412f439430b2b85b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6090f28b1098cd64d532419a5b5d585f48f27b6ec40e8eb250a6ac7fc1b642ee"
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