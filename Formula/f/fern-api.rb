class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.81.0.tgz"
  sha256 "424ddb5be2b5de3ddd4c76fba53c5a71dc2c2efdce58c9b3c33acc2ae557e512"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dec67fa35ee19b27c4b1f1eb154e09d0fa01b0d24bc51a782e972a3d7761aa2e"
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