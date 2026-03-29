class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.48.0.tgz"
  sha256 "0bb40bbeaac074ac546e42b1982bf5aa256c5b305fa3ed6b6678bc34ffc1de99"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02acf20d1e1543d32315bed8861edb2e298278b05a86e95f4356b39b2a911257"
    sha256 cellar: :any,                 arm64_sequoia: "219cc15c261876528af42044f29c5d50a117ea26db02d99f1a66aea68da55a04"
    sha256 cellar: :any,                 arm64_sonoma:  "219cc15c261876528af42044f29c5d50a117ea26db02d99f1a66aea68da55a04"
    sha256 cellar: :any,                 sonoma:        "0fbfda1f255eb789aa85c045c63626d8cf37df70da4683a75a5c047e3b066745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dec280d2e50ebb562d1a092b77eed3ab51c13777cac631afd6c1e8f569aff7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bcc5ab8312f7110aca3a7d09efded6d08048f76c57f180de6b72e5acb20789"
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