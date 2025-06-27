class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.24.tgz"
  sha256 "17401c1a66e44271d24c3394c5584f285d69eec6c37fde2799e31da3056a7115"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1cc4d1d62a420abf8962205e078ade896a7c0f89cec55cc46ebd522670981284"
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