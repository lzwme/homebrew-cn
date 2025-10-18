class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.93.0.tgz"
  sha256 "b0b67d54712d40f897c40652b1ad5205189fefa73b87959cde25e45e9118404d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb3c171cdbf9760dd2000abc2164222d32aebfe2047828cb237858fb3727d3f9"
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