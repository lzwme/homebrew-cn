class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.22.0.tgz"
  sha256 "959c1f8553369aa1bda6d5c7c9ec81363b98f8415ebddd1e3f476b2bc4a9cb6a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d378df7cb92190588ffde561b63b9eb204c0229c130af3cd02c4f386cd55ef1"
    sha256 cellar: :any,                 arm64_sequoia: "1b7030ace064acb16e2e8d93f6ed0a1e8affe0511034f49ff5c43a77307b687a"
    sha256 cellar: :any,                 arm64_sonoma:  "1b7030ace064acb16e2e8d93f6ed0a1e8affe0511034f49ff5c43a77307b687a"
    sha256 cellar: :any,                 sonoma:        "35fd2f8784972964e3c4c2c9f0fc5ddac663c75b027a7aa42ee5d38c63a7e007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14ed620c5f7e446f2c402eca75048a6bf6f859188c61c146e78df22ed4f97b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b12bd7eb53aaeea12edfb019ace617988d7bc6d0d42e30ba6e2d8f4f10eb8d97"
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