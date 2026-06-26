class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.54.0.tgz"
  sha256 "5f0c139a0099e1c14d72f9a1a35b590eac4f1377e6e5b5a1a8bbd88470dcd2d4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d23d91fa47e5bbd03702ce21e829b4f109deb09ce8bf76636bf8f6a842bf6322"
    sha256 cellar: :any,                 arm64_sequoia: "fef434d97f8d461ee31399e1113bed742477a95e143a680df6cdc063524338fa"
    sha256 cellar: :any,                 arm64_sonoma:  "fef434d97f8d461ee31399e1113bed742477a95e143a680df6cdc063524338fa"
    sha256 cellar: :any,                 sonoma:        "14415cd5f4bfa7ab266e2b53b4d632985009fadce356f7427c572865ee829b56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2d4e941b68b10ff64f9740f646a4911fca73e4cb04586680026e239517ce46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8674ddfe7ab1f91fb112461fef569d0669172a803a0b06146e9a7eb23828d3"
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