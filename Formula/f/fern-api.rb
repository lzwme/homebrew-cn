class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.78.0.tgz"
  sha256 "a2460fb778f5852d2891abe686b00fdd8604becc01bbfd899887b5f18754fb69"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1614fd3a3d11e935c30d34588e076129f59925fac7606e68c016e36af79b29f5"
    sha256 cellar: :any,                 arm64_sequoia: "32023e2d822b3b98e4aaf800a8c9b3d3b10b4ab6f494857c54184d09136472dc"
    sha256 cellar: :any,                 arm64_sonoma:  "32023e2d822b3b98e4aaf800a8c9b3d3b10b4ab6f494857c54184d09136472dc"
    sha256 cellar: :any,                 sonoma:        "30e9439ad6923636c4351135d515289316fe9b0899c4327d8b4edf07f3016a50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaf2d586c611fef2da11b435a1a5d5006db188ed228787e60e51089b71361958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca1ad09e5cbb06823a9962f49707643733a538548afdb230b2aba9925a3393b5"
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