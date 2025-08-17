class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.66.17.tgz"
  sha256 "d8b41a4068fc9e62c0e46d903dec3585e687c14a851e2063f098d8700cbb5731"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0bedab43fd123caaa4dd3e99a58c12eefeb7459dc06e0bb5c9b6efd9d6e38ce6"
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