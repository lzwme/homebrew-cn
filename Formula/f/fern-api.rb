class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.22.2.tgz"
  sha256 "dea8bf711b3d23649539ed0decc2091a28706f84bc5bb7eb247edced56b18f84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4aef2f15177cd61b5f08b01abd6c2380d8cd0b84bf4e1dec6b17f5e0966a766"
    sha256 cellar: :any,                 arm64_sequoia: "5b5b8b22985476bab6533c65b8c1a7f9c5425d20b7b78198055edcec8d44536d"
    sha256 cellar: :any,                 arm64_sonoma:  "5b5b8b22985476bab6533c65b8c1a7f9c5425d20b7b78198055edcec8d44536d"
    sha256 cellar: :any,                 sonoma:        "80c1fdd599016731f1307d85990f64455e1064b526b2e577a40de52de8eadf27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181dee582181d3e1ee987a4a2a6a0b6561226728af3355180a4db592f51ce8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46ac278e26c397ddddcef97981dcdf764ca3b1df4eab69e27a084d9d63ffb1d"
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