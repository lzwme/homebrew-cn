class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.30.tgz"
  sha256 "6870e869736702db8a33efa675d9153d81641ac3e283b8dbf8fda40b623c5982"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5431d6b05c2c2e3b8d5ac59c296df7f089ad6c8592282dd31a57ed1687534e8"
  end

  depends_on "node"

  def install
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