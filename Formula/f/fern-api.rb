class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.90.0.tgz"
  sha256 "8242d49dc9b49516ca5acd6521d5bfbf01dbe4ab0d014e25d29dfd5156f79aba"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e4ea2c91ae7cbb6e2c29a599eea10b146cb947ed64c6581b86996dbe530cb8d"
    sha256 cellar: :any,                 arm64_sequoia: "a02dc9e0d8d0d34cf59d634443864f3ca3e63d00d085b8b57acddcbfc35ee969"
    sha256 cellar: :any,                 arm64_sonoma:  "a02dc9e0d8d0d34cf59d634443864f3ca3e63d00d085b8b57acddcbfc35ee969"
    sha256 cellar: :any,                 sonoma:        "1d840aa6d31f2b7c55e3a564d5a302f17af53367e704ece80a0822b986702a89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c956f76286c9517bb2f92028b75014f69070bafdde05ff4ada4fb63ed7babf3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33bc52820282ea15c0def5257b32ca5cdc45ec1acb0b016d7ae954d50df8b9dd"
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