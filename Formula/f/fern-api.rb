class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.30.0.tgz"
  sha256 "92199555d8a02180c62ed72e6482ff598a67c204019c8cd5f395a84950aea8ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee94ba8492728583a3007add5adc0036cf9adf7cf6f5cf36b8bd4af35b396bf2"
    sha256 cellar: :any,                 arm64_sequoia: "3c6c3511320f02c40a80a1769ea4231478d6d2c9eae17be1ea5090f1b195482a"
    sha256 cellar: :any,                 arm64_sonoma:  "3c6c3511320f02c40a80a1769ea4231478d6d2c9eae17be1ea5090f1b195482a"
    sha256 cellar: :any,                 sonoma:        "b56f836928c09e347abc9fb2b9a51efa59ec6d1ff7fa03508f8af57306f42634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efa3c8866fe87d41df1a774b424b506cb8604ee7f3a2369aec9117d823a60423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c64c78b010e88552eb47a69cb2a09961f0edb4d56a88a4dc5e0e9d5362d45772"
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