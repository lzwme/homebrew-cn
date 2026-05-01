class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.2.0.tgz"
  sha256 "66d6f090817ddac296331e20811695c60b1a639d6881f8d96e6635892c454f80"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc6ddc319b2728395acaaa4810fb9384c78414873806c7177019a01cf5de0ac6"
    sha256 cellar: :any,                 arm64_sequoia: "96a9bd8f614db29fdb57f7e78712f44bfc71ed212a9c2eda305fe91b57ba7d32"
    sha256 cellar: :any,                 arm64_sonoma:  "96a9bd8f614db29fdb57f7e78712f44bfc71ed212a9c2eda305fe91b57ba7d32"
    sha256 cellar: :any,                 sonoma:        "76296977ae77db711ffc1499e0b6863fbca73bb900aea59b1427c8bfc7ce2881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cb3dd30efafbf1d53e00df20072754947fdb1ee0f275c1be999b0e6ae525517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9210ba32604f280d229692474cc5353e45e61b523c10e5c24b2f6542857ac4f"
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