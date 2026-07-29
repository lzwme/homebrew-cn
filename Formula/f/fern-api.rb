class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.82.0.tgz"
  sha256 "b9d68cc74387fda52f46f839034689dc429b28ab0709cde6883918a58139cf04"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "038f8d0245973aa8ad7e8f18b8420e0ced2febeb09c93ba03d01c10d1670ff3c"
    sha256 cellar: :any,                 arm64_sequoia: "038f8d0245973aa8ad7e8f18b8420e0ced2febeb09c93ba03d01c10d1670ff3c"
    sha256 cellar: :any,                 arm64_sonoma:  "038f8d0245973aa8ad7e8f18b8420e0ced2febeb09c93ba03d01c10d1670ff3c"
    sha256 cellar: :any,                 sonoma:        "287276ed7a8e9fe5c8b6b3675e68a035f5f15a807455a018e60c384cf652ceef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55d70d15b8cbeae89b00904bd7998cf457a59f0b6186f27f1df79d84e76d44e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e03bcc5f4c31e06e29cca22ca57401132103fe011ee71190c741539527e1835"
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