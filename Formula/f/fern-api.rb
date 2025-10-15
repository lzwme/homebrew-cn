class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.90.0.tgz"
  sha256 "435e92e870172d3619a17f7ede8f3d4da30c36a368ddb46fd31933fdc77c02cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "812ce7724ba1b9fe5ac7013a6ef5472fba19a9a87df1d17c82c44210fe0d98c2"
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