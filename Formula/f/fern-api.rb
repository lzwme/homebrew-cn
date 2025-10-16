class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.92.0.tgz"
  sha256 "20ac0a2d34057048fa1b25813379ed391bd45ecbd868eb8954b2d76d5ddd8012"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7f7480136614b8831d6be26f5d044311d1bc983aa4918349fe456ee7e78c061"
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