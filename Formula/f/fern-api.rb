class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.76.0.tgz"
  sha256 "2a21af9039b4563cd218a6c1e9b2ec42ebe4f703c8eae39bd64479a5cca82065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dede20900dbb5bccf2f0e2173068588de193c82488d02dc3a6e9097859f45a2"
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