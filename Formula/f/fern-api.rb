class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.41.0.tgz"
  sha256 "4693f0602531abf21080a14a827f0c733cb494f7adefcb304bcab43f6e0628d1"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e20f0a197207630c617cb4ae69fb5d81ef2596a5520594639c79dc0148033ab2"
    sha256 cellar: :any,                 arm64_sequoia: "9691dc2cfc7fc4bd1f4383d28412cca1abcda21ca63c3f08fa4ff6534e85968c"
    sha256 cellar: :any,                 arm64_sonoma:  "9691dc2cfc7fc4bd1f4383d28412cca1abcda21ca63c3f08fa4ff6534e85968c"
    sha256 cellar: :any,                 sonoma:        "fc29806bfa1768675ad17e5a7820c89a1b4b408175df9e19db24cf3fc8c95470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cbe9dc5583e4536037f6d965ef6a1ea7c91abdf7cf1e7da964f0e7b09fcb824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268817eb59d5964a65219de5f561ca9daf05e3cc3c581d5c0a5a34d51fea6f90"
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