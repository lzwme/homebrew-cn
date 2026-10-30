class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.186.0.tgz"
  sha256 "fc7c45363a071cb96b62a18cf23956499023f2f7bbaf65cdc7e0348f8103b61a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f7134b3840a25ac087e75ac30f5a0872f3d7d3250666f558d53b59f32dafc2a3"
    sha256 cellar: :any,                 arm64_tahoe:       "f7134b3840a25ac087e75ac30f5a0872f3d7d3250666f558d53b59f32dafc2a3"
    sha256 cellar: :any,                 arm64_sequoia:     "f7134b3840a25ac087e75ac30f5a0872f3d7d3250666f558d53b59f32dafc2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c3d53f817be22fdede3e6b77ca3c17a381092f16b7964c8349efa8373cb73f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "74691247e96fc26a6494f230444282054726ad9c0a3ed41afb33ae77feb43e9a"
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