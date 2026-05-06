class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.12.0.tgz"
  sha256 "9a26c41a5dd8b9b4f0b61b876dbee1f38a0d6124a4f8a5b7ca7a44a44bec6f17"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74e0acae065758771e7886b96ddda30dd246cd724b1c657700ad5df2f3deff2f"
    sha256 cellar: :any,                 arm64_sequoia: "c5db5fae819a312450fe4f3d6118d38199031d08707b702ba598dc535aea45c2"
    sha256 cellar: :any,                 arm64_sonoma:  "c5db5fae819a312450fe4f3d6118d38199031d08707b702ba598dc535aea45c2"
    sha256 cellar: :any,                 sonoma:        "363f96062c05e042e6448707fb039c53b364dfa9b5972a63aee592d2dde502a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a915c4fd956063c83c5a4806459897e56fd5f615ee0248bd7e3a4e02e5ee58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b83a9abb0689106c381efd90e60aa8b4bccb3c061fb77f17a57c1969e8a053"
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