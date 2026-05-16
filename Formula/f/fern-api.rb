class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.26.5.tgz"
  sha256 "7796c9a932b9188b484baac07948cdedaadc2e3206e9bb33ff893bcf6139cc27"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f266895e8ba733516bfd5bb19491e4809e953b987c84db77483c34344a99fd76"
    sha256 cellar: :any,                 arm64_sequoia: "e88789ec4a6df4e95fe21d67c36b97b2f6903681079e5609b754d54726b95214"
    sha256 cellar: :any,                 arm64_sonoma:  "e88789ec4a6df4e95fe21d67c36b97b2f6903681079e5609b754d54726b95214"
    sha256 cellar: :any,                 sonoma:        "c011d9b9378c5b291589a8d5e0a0261c39d4c7f33fdb934715318c9675dea34a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ed28ea06a88535d383f30e3f177d9941f9c61c10a883d778217b33ecfcabf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4368dcd7bd8060f019e3b9bd674e9df03460eb90ba9fcc3f7a523499aa7d42e5"
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