class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.177.0.tgz"
  sha256 "fb070689e543afd9d341d118d998b2574d6a464bc0f7cdf73308491dc9a56d3b"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "4262dc88899c8f6a5f9eb3b58fc2482e5540c0c520d1ee9a1cb5e799668ff883"
    sha256 cellar: :any,                 arm64_tahoe:       "4262dc88899c8f6a5f9eb3b58fc2482e5540c0c520d1ee9a1cb5e799668ff883"
    sha256 cellar: :any,                 arm64_sequoia:     "4262dc88899c8f6a5f9eb3b58fc2482e5540c0c520d1ee9a1cb5e799668ff883"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1bb7769e7e1f12081d7a3baf42c42588836abcc9de928e1c760fdc7e9370d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6fb77fa792c582d3b7505c0367847a15a7a6998f9b018f92fe87360a1d10e22e"
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