class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.88.0.tgz"
  sha256 "bad061d01b8b70a19d2cf7a1149150b5261b5e506c136f712cb3ba5158c177d4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b01efce6496e6daa9403899386fe462751de581b5f1d8a4024d4a890ac898537"
    sha256 cellar: :any,                 arm64_sequoia: "4abd324683264c69c450b6e3f84ae6f26fbb3fd68816ce81371069da3c543ee1"
    sha256 cellar: :any,                 arm64_sonoma:  "4abd324683264c69c450b6e3f84ae6f26fbb3fd68816ce81371069da3c543ee1"
    sha256 cellar: :any,                 sonoma:        "aedbfd821ee8e5dd8aec27a10832bdcda44ad12fdccaaaa13fcb0a34a178ee2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c4ce1790f78a9afe70a3be8dd33255e99b9518a323ee0eec222ecb1dec1b489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820c1b965374fd7cb3884c12f92d8618af3f62b4e3607060ced67a56bd9f767e"
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