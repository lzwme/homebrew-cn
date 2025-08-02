class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.43.tgz"
  sha256 "9d1b6f39576b67bb0909422affd5f3edb9e573e1f482535c992fe53086f58867"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca3312081ba4b2a42e8ff0fc2f107435945d5df0002beee327904d0f6fc19311"
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