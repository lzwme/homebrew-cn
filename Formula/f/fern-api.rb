class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.4.1.tgz"
  sha256 "e1564fc3bf16c82a4390c12aec3e66bef9b79063c8f2f3f2ef59cbd55e12605b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6946909c3d7140cd3db1329b2c304b72a90a8551d85025505f90e05f8b2d3523"
    sha256 cellar: :any,                 arm64_sequoia: "41f7affdd765c47c8d27849923dcb614dfa01e8582c4a5de00be353fcf96c48b"
    sha256 cellar: :any,                 arm64_sonoma:  "41f7affdd765c47c8d27849923dcb614dfa01e8582c4a5de00be353fcf96c48b"
    sha256 cellar: :any,                 sonoma:        "c8d7ce51915e9d12d6a6e1171063ec80093c4904cf88bbbf69f02fb9697f4fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "572bbfb64e77ea1060630f1e64177dd7ec64729f75470607aa9bb80124f20af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "662bc6b9ef04fa6e6e37f7f863251f60388bf6eaa362be640b2a1b92f9a0a853"
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