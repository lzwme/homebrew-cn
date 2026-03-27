class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.46.0.tgz"
  sha256 "19b028336de04e1a62051ebc9a28149a5320717dd1bf70d3549f9f225b0a5cd7"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d609acdb923135aec7bb9c45feb88a1fbaec7c28792269cef4106c912193516"
    sha256 cellar: :any,                 arm64_sequoia: "3fbd51b9124ad8b1ef284a806d51282e0ce6bb8a2507589c7da4bb2d4f71d2d1"
    sha256 cellar: :any,                 arm64_sonoma:  "3fbd51b9124ad8b1ef284a806d51282e0ce6bb8a2507589c7da4bb2d4f71d2d1"
    sha256 cellar: :any,                 sonoma:        "0023188dc23afcabdc6903d6ab07362db6d52aa87c83e02be0d5208a3fb590de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7443242bea05551fbee89f01b0946af5b72994a16e226907174b9722ce194529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8283db596699907d94cb3980831d1d18f2d39f2d2d79bd9f71375973cc1b637d"
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