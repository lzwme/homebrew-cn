class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.32.0.tgz"
  sha256 "3ef0e5a75860bf5ecb74a4def91796a309d99c08018c52aaa9d64eff90ffd3c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57084ebc3abb07c993a3f03d6252f664945541e2724c6364f3c7049875cc37e2"
    sha256 cellar: :any,                 arm64_sequoia: "e12626204725f21cf676699b6190a4ff58b4aab459a174390c8f8889be42dcae"
    sha256 cellar: :any,                 arm64_sonoma:  "e12626204725f21cf676699b6190a4ff58b4aab459a174390c8f8889be42dcae"
    sha256 cellar: :any,                 sonoma:        "8326224cbc3710734945b376fb5b99ede543863a269f1123050ed4a8b1b600fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74a5b836c21bc729903b9daafd281078cfa760d54ac37a5b26f732f7effb71ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c698c55e26a0ccd4d857bd093ae55e49dfc051365ffa71959e91df0f9fc68d"
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