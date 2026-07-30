class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.84.0.tgz"
  sha256 "87dc4cda10fd056b3d4a78aefc21c402de1b32475b80b63fa18bbf0854841cf8"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7b2c9bbcc3433fcd08c72914791089cdf49dfb81a91e27390f8548645113b2b"
    sha256 cellar: :any,                 arm64_sequoia: "e7b2c9bbcc3433fcd08c72914791089cdf49dfb81a91e27390f8548645113b2b"
    sha256 cellar: :any,                 arm64_sonoma:  "e7b2c9bbcc3433fcd08c72914791089cdf49dfb81a91e27390f8548645113b2b"
    sha256 cellar: :any,                 sonoma:        "d107cc4bb7d33f0a3f32b8167415e0e102fbb3e5c3f4499346ac8faa44b870ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caa5129e14575fb8a0dc23b02ca09efd93fdcc9499981c64b0d2214a344d03f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b88909fe336e437b4ec8ca33f6780a84ad55f23f75a209d316b253b0a76768c"
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