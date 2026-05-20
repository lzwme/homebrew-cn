class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.29.0.tgz"
  sha256 "98ca5609ab37387c5c3186b20eb03db3eafaf65252bb1520ff77d08c168cc5ab"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04df7b5a6e6d2623dc708db4d1d896700c35c5f0810b94900bfe94f7d192818f"
    sha256 cellar: :any,                 arm64_sequoia: "900741eaae422348181dd25d4275c6542b7f32ec4acc6c6a008c8d03e3077fab"
    sha256 cellar: :any,                 arm64_sonoma:  "900741eaae422348181dd25d4275c6542b7f32ec4acc6c6a008c8d03e3077fab"
    sha256 cellar: :any,                 sonoma:        "e153eb3460a2b941f309a9c38d72880fb0cbe4fdf12e19bfa08c549ada0adc27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33d063364673d2c2e2c871f2ac224e0a847c87b483e4d1c63dca4c528e3c023c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20252f78ba4097667c1ef90d67d95146d449cb8797bc62a3ba3f988f054241f"
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