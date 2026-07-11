class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.68.0.tgz"
  sha256 "d3f0922db5ea5a25ab7efdd573f4e371483a754a9e3f1150cef7ec3dd5b157c7"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e81e8a430c4285ae8c38762e8497695ca5b7f26035a468e3c1ef6c9c74f84e2"
    sha256 cellar: :any,                 arm64_sequoia: "766d0edb99e487b6d9f05fa7671676ecca70197c900757dbc0e4a2541832571c"
    sha256 cellar: :any,                 arm64_sonoma:  "766d0edb99e487b6d9f05fa7671676ecca70197c900757dbc0e4a2541832571c"
    sha256 cellar: :any,                 sonoma:        "752af7df90bc4062b040d60526710ec9058a6835b808f1025d78371204c3dc67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cf604064e216fa6f3fcf7c41621bba2971bb85c3d5bcabaef00793d68be9f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dacc0f8bfba023b6caadef766f2306f5036c37898e42fce0d567b98a2a52edfe"
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