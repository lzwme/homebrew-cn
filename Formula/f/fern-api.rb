class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.79.0.tgz"
  sha256 "d8d50c374e6e07556ed3315d5375261fbdc8146fc66eaa86a5fc934be5488131"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "516e8530fa5b56dcad9633585f54e220a2ff8140a424a541b77a61b47f4c971f"
    sha256 cellar: :any,                 arm64_sequoia: "46e7ae1eac99476152e7f597ee459de3a11ea26c2afdb4fe8167aae439cc35ef"
    sha256 cellar: :any,                 arm64_sonoma:  "46e7ae1eac99476152e7f597ee459de3a11ea26c2afdb4fe8167aae439cc35ef"
    sha256 cellar: :any,                 sonoma:        "e708bf77c7e5ff86d73bca37f11d585c7e348eee7ba5aa0c0b31330dc49a72f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244fb950fe77432d119823a3576bd6316eb70f467b9b537fc37edfbd9d8ccef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedc735c2084f8d22cafddfc3ec3e8ef09a581b442e46a4b9f88b93036aed0b6"
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