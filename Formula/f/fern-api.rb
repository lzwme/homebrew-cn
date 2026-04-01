class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.52.0.tgz"
  sha256 "80410c42fd1b6e221ad0860660bfccc09030d6122544fb202cc402af21fe0595"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ee2f3e3e01bc8813ac43fc59d30f30eab9f0e2aca11533af7bb40267cbf96d2"
    sha256 cellar: :any,                 arm64_sequoia: "d6d3863233af21811ef28b8a945ba555cd867f3f0084fd3679c0572d1d3fcb5b"
    sha256 cellar: :any,                 arm64_sonoma:  "d6d3863233af21811ef28b8a945ba555cd867f3f0084fd3679c0572d1d3fcb5b"
    sha256 cellar: :any,                 sonoma:        "2812c16ff5d983de069f3bf850c87742d65124eebde1e4a6d19f745264a60bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09fffaf3e273356c578b3c0d8800dd1c3cdf01a0fdde88ee168e1ed5cfaec14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47d08aab30d740f9e4693a66b75da47d3270dd7cfba988a2f6dd806fe1eddbc"
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