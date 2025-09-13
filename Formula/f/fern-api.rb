class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.76.3.tgz"
  sha256 "282b66b4d9c89d60525445480e73ca75ffad447bd5574e01c85b705596b154a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80fcad56306ea41315a36380a7c03990924ee4c87a19c61914ed603b3c9cd0b8"
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