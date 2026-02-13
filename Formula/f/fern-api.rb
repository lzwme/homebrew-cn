class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.76.0.tgz"
  sha256 "32d7cafc513435e932d7ed286776f6826cc840a6cdff09f810332bcca06d2d0d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "513fa354e224d660a0b55349caefda7fa0a0a1456a476bed117c7d7308aacb4b"
    sha256 cellar: :any,                 arm64_sequoia: "b6245385fa2039c0dac5dda3f58a3bce61ea91b52f35dcc087402ef0d78ae866"
    sha256 cellar: :any,                 arm64_sonoma:  "b6245385fa2039c0dac5dda3f58a3bce61ea91b52f35dcc087402ef0d78ae866"
    sha256 cellar: :any,                 sonoma:        "960f4eaf0d9c579d3dfc4735affa724511c49d1b44fa3817402f6d44f48ea2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1420656fde2904b6e51ede2648d3e04ea29d7ca12be7df9f2a2624348624cf0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f81d79de9ffdcc8591270782788fe9db47ab22b7b39cb56453933e31c28fb0b"
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