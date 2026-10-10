class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.150.0.tgz"
  sha256 "c1aa26006e9a1054c22916bf9dbf7693c59636cc9d660726616e1de48176e0db"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6dd1a24abb35a8f8f132bff80e43d9e857522adb7a1c4468a114a53549a08693"
    sha256 cellar: :any,                 arm64_tahoe:       "6dd1a24abb35a8f8f132bff80e43d9e857522adb7a1c4468a114a53549a08693"
    sha256 cellar: :any,                 arm64_sequoia:     "6dd1a24abb35a8f8f132bff80e43d9e857522adb7a1c4468a114a53549a08693"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae18e3a7675cafd1301e8f2c50e07c695f0a041becdefe7fef0aae80e184e7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "178e964afd5e0729c131894adf6a51adf03abcd7b87535ee6256eb4bbe429afd"
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