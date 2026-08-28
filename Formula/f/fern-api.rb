class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.108.0.tgz"
  sha256 "fb2e1c3123125945d52a76a34bdf4d1f90d7f6fab3b4ed8acd0fc2cb71fa1930"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e8b43b4dd0a49e6d42211d675925fffce0af644eec2b11d5575819f2f72e7fb"
    sha256 cellar: :any,                 arm64_sequoia: "9e8b43b4dd0a49e6d42211d675925fffce0af644eec2b11d5575819f2f72e7fb"
    sha256 cellar: :any,                 arm64_sonoma:  "9e8b43b4dd0a49e6d42211d675925fffce0af644eec2b11d5575819f2f72e7fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878db2acdaf990e4a4c30d03dd7aacbab101743b6785c93aaaadbaf9209a49a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4318c7dda413881f46d38ba98c613b761fa3b8c22dcf398fe1f1726021ea4bea"
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