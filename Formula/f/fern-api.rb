class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.74.0.tgz"
  sha256 "e686eccb4e2cba9c67d4367fd413946f46c728bc15ead6e9edd9240b8e101e88"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74b48141829fb1ad2633957e4ca1976d002e6ea7513b9013d5cefdaa66a6986d"
    sha256 cellar: :any,                 arm64_sequoia: "327bf4aceedf7e763a0a02d254099c6a8db220ddedcac1e15edfd7fa2f649bd0"
    sha256 cellar: :any,                 arm64_sonoma:  "327bf4aceedf7e763a0a02d254099c6a8db220ddedcac1e15edfd7fa2f649bd0"
    sha256 cellar: :any,                 sonoma:        "9199ad8dd3ff50dc3537e5ec802d738ffa408fa9462f07cec399da76d34f3cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb9606ecf8bf5be55757b0d72654559165677746233412fff12d0167d321e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9755db30b032397dba69de5fad6e84fddbf7bbc817f2a55fe2e15376a5097fd7"
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