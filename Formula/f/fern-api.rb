class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.82.0.tgz"
  sha256 "c592e13d9c11feeb09bece93c9cf45a6e0fae17fde8f5dad33c6a869512b23ca"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb145c6c0c28befd74a7b4152231221329f1618c1cb6289f8c0e1d97b2f5a863"
    sha256 cellar: :any,                 arm64_sequoia: "7f298a0927421b89ca3d6d38058e97ad9d68ee442a6a8aa954e352687c7ef9bf"
    sha256 cellar: :any,                 arm64_sonoma:  "7f298a0927421b89ca3d6d38058e97ad9d68ee442a6a8aa954e352687c7ef9bf"
    sha256 cellar: :any,                 sonoma:        "5f70fc879322fa296bd8eb8e7febbbdf27d5c100248730d48fd24eb979397aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab570fb605a290d573f2caa2d630db2982b6cb5b451f8b777289f279f54c5a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e60b8f6d23c567fa04725330556f87eda149b507990a7233a4e3637d29d22c"
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