class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.64.0.tgz"
  sha256 "b6d254230b187cb9ecc46809989c2ce44e2169821fe4f9c02c1cb645bab0def1"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e2e1d02c19f7c5a4a299030d4ddf6ff791b78a0fe3f212efe6a8dff9e157789"
    sha256 cellar: :any,                 arm64_sequoia: "423d64c9cabea9d0b684eaca4c586ec5110131d274f92d7b8748e87e300ddb64"
    sha256 cellar: :any,                 arm64_sonoma:  "423d64c9cabea9d0b684eaca4c586ec5110131d274f92d7b8748e87e300ddb64"
    sha256 cellar: :any,                 sonoma:        "a25ac07df10b951dddc3a914e961dea863b4c3c00e8e6376c92d3ab4b7ad6188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "398bf323f9b5a4d9ce9f02d3fa8522bc2efb9adba236e5c90f77655e24ca4380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49cd70d390a65a1c4fdc8a9598cd17e24d28721c5835df033b22dc8480ef39b5"
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