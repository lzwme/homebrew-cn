class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.36.tgz"
  sha256 "ba360729d72497c6ab852616fea6e44d74e68d0ab6441ab8cb1d8959f93ca62a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2b51537b15368d63fab8c8c3e0a749b9b696325ff836a532a689e577f61c38d"
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