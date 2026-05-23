class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.37.0.tgz"
  sha256 "eab658dde0050d907ae2d9ea28b168396881c9103c954135d9f3a44422602b3f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32a90c53dbc50c83df68b49f303a1e1de232ffa618a6520f09a8c0db9aa26aec"
    sha256 cellar: :any,                 arm64_sequoia: "56692a1f9f60c25118bd00e39f824da480e70f630615699c1e9d860354611fcc"
    sha256 cellar: :any,                 arm64_sonoma:  "56692a1f9f60c25118bd00e39f824da480e70f630615699c1e9d860354611fcc"
    sha256 cellar: :any,                 sonoma:        "3362abc6e11686b5633209ee09d3c22cbcd9d30cbaf18c363c543f25a2278d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f7f04ef5d49ad662c5d475e65fdf6f94cb3f569215d02fdfa08628099eca2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f19acea9d3ec4ddf77e9374d7a186adf9f4400b4a0f15dcb4484288914c56aa"
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