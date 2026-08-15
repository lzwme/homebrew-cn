class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.96.0.tgz"
  sha256 "0fe3a7a35083432a957b5157d25899a8de412b3d60fd3da42150bdc429b56f5a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f94c19b841ede443ea0b754cfccd97323054f397824f62909f9a6591f5695b67"
    sha256 cellar: :any,                 arm64_sequoia: "f94c19b841ede443ea0b754cfccd97323054f397824f62909f9a6591f5695b67"
    sha256 cellar: :any,                 arm64_sonoma:  "f94c19b841ede443ea0b754cfccd97323054f397824f62909f9a6591f5695b67"
    sha256 cellar: :any,                 sonoma:        "fb7489d6df9cde3a48c9693b37b3c4d10fffc006edb79186f1d8d47600cd4ba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ed12df8e05e1526ab87b7780f263872a6287801256211ff2d6ded6e2a92818c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d4eb14bfe8eaf294bb9ccc8b48b568649c13026d16ed9d455c9bec5f460a7e"
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