class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.6.0.tgz"
  sha256 "01b4b7e641a0c2c4371f7282c6d7664ae6ab98b3c20e44b8e52fd6bdde79c7b2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5af28aebb7a5ebc4008e6cb594e75eceefd1b4ca81bed34e78c705006246362"
    sha256 cellar: :any,                 arm64_sequoia: "d5288c8c9b3a2778af52591577e7c28b317185375b75973f7f12f9c8b2d62fd4"
    sha256 cellar: :any,                 arm64_sonoma:  "d5288c8c9b3a2778af52591577e7c28b317185375b75973f7f12f9c8b2d62fd4"
    sha256 cellar: :any,                 sonoma:        "3c91b95c675bda924a3e55304eb49a68dda67bae5edf7252a39c54059dc238e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236849e967b82e2d3cdb5156f3aed2eebd6a27ea5862d68e433bfa0387ee4317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e742b0a7843740d6a08e81fa0be85f86339332954f1b6bb37ee5675480a76d"
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