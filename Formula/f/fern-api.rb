class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.1.0.tgz"
  sha256 "d04bbefa24bd8edba08b8264c054e38054f56181edefa8c545655f2dde018b06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62a82a9a22c60ba4de83d8d2d19f20082a6276b76f9e03470977d01a54615b06"
    sha256 cellar: :any,                 arm64_sequoia: "7f9e5302d0011ecb7144f0a7523c7517997813f1dd63913edc43081078c618e4"
    sha256 cellar: :any,                 arm64_sonoma:  "7f9e5302d0011ecb7144f0a7523c7517997813f1dd63913edc43081078c618e4"
    sha256 cellar: :any,                 sonoma:        "a07b62d21749ca3911625ca70cb4a5887d47097d6d18f02f7f9447f07e9bca98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555491e155d27ccbd0192f72c5e853533783a19394cf77a2366abf4622320a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8fd482b8b048317eb9d631e424f1510529c0399fedec793a7450a060e30f0f0"
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