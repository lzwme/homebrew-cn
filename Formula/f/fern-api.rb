class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.95.0.tgz"
  sha256 "ea723d23169dfe9fd6da704620aba23d14322b292b604b17581851a8896faee3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6bd89c1d903825708e540f02c71ed0b659f884cd8e7f4622d81923ac814dfd47"
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