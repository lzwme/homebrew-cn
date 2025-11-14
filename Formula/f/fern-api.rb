class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.121.1.tgz"
  sha256 "365b74278534db2960d3b83b4cae1a7e4aa38f5d242d34d7e2c030c8a2ac5843"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "917ab0f0a7f217977719b45cf27496e48c9044695d89e0d0153913c4e8bf7173"
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