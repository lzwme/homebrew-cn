class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.94.1.tgz"
  sha256 "094a440e8f664979c511321b76c8f979b2a893168f72b38ca0da356a584a82a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1637cce1c6d8c32c3041678c1a83d80c3de9edcd279303a728ce84cb665ffed"
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