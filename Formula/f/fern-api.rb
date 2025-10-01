class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.84.1.tgz"
  sha256 "23dffc4bbbfb0ab43a90b2c3f118e3f248fe4a14936ad93e7bf2b4371ad1088d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9387ae0bce846570659b5155d1509e17e41ef606e53c7629b080478b035190d8"
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