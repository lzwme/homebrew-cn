class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.99.1.tgz"
  sha256 "12855c50fba375bde93c0ad1b58b43f55e7db4b5c5c74104aa9a368daab5ab34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58623d07f57b9e5faf10465b1497efca2f836485c8f552db55c517c250de7e6c"
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