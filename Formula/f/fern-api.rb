class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.18.2.tgz"
  sha256 "60ac81e65a0fb24412dd170427ab72128a1b62217976b8a6b39294c54bfb7705"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8460840c39599f2100097bf672ea4d843e6e656bd1d3105b991969560e1f3df"
    sha256 cellar: :any,                 arm64_sequoia: "daedb6100d0eb87e83db0f7f89a3a41e3c900da45d4493752c0b02b8c6137941"
    sha256 cellar: :any,                 arm64_sonoma:  "daedb6100d0eb87e83db0f7f89a3a41e3c900da45d4493752c0b02b8c6137941"
    sha256 cellar: :any,                 sonoma:        "7f0aa7cc96274e3737fe755943a786a08d2db933efd02d9ef912cd3c98a821f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6e014bbfa1e8317f2cbd88e2596b6969e4a2fb7ca41ab1dfd98ca7e80e5eeb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c58b192c3345563bc532c56b7f08d7591be5887f3d7796d4bc970688406110e"
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