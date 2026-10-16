class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.159.0.tgz"
  sha256 "16157f960d572260e0425be008f019083eac127af0876812e61a2b6b10dfbed4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1779030fbfa3b09d811bbe45c34879e8c82ace39bb7ff543b559d0bebace67de"
    sha256 cellar: :any,                 arm64_tahoe:       "1779030fbfa3b09d811bbe45c34879e8c82ace39bb7ff543b559d0bebace67de"
    sha256 cellar: :any,                 arm64_sequoia:     "1779030fbfa3b09d811bbe45c34879e8c82ace39bb7ff543b559d0bebace67de"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "65d9c4bea9b681233d0929d6c234eaff1f4eab487f59c1a973be7a1672b848ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "be40e9dda2948b32a032038cef6316897eb00f254367e98b40fb8cdca91bfa47"
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