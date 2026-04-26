class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.96.0.tgz"
  sha256 "050c01875ce0f6297a1b075438572a56ce10ddf87bc5bba73646c761d751620f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "851f2a236a34e1fd53b14860c75af2ef3b860d3d8c39d2f05d09ffb9b3c1bdfe"
    sha256 cellar: :any,                 arm64_sequoia: "0290022b47d75010f3e8f5ca3d34fabc7ea933616590e7aeb38a22d91ba04236"
    sha256 cellar: :any,                 arm64_sonoma:  "0290022b47d75010f3e8f5ca3d34fabc7ea933616590e7aeb38a22d91ba04236"
    sha256 cellar: :any,                 sonoma:        "6b6f12046c1c3e203dc2d1a2e059db0258373ca5933874e9532b5acb508330a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d14b0c2f724920684d818c5bb16603b7c9f73770bc379aea8583b3bf405a6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e084f35af1cfb9901bf390c0aeb502d2d91c7d4ef2fbd789c7dbe153e9e09a0d"
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