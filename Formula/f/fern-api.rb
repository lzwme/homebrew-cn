class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.123.0.tgz"
  sha256 "5963c07da00154c4da2782f229342326bf285fc038cfe1231f681824e9c4a4c1"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "7ef0a6d15a369c92dcc2c009ac4a48816bb45f1734135c7e65c6af317cd7aa43"
    sha256 cellar: :any,                 arm64_tahoe:       "7ef0a6d15a369c92dcc2c009ac4a48816bb45f1734135c7e65c6af317cd7aa43"
    sha256 cellar: :any,                 arm64_sequoia:     "7ef0a6d15a369c92dcc2c009ac4a48816bb45f1734135c7e65c6af317cd7aa43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "504d4f95892fb99c71538381186719ed77dbe3e2d2279e8802f4c8898326e5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c2239c8f9f237444553dd6363c169b8390e210c38e3dd5075c47261d52e9a8c5"
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