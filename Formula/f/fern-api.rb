class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.14.tgz"
  sha256 "33f386e01d5e5285c85fa476cbda26e91a0d441ee5288263850b4bfa1feaec95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c197b63ab4825eaf2e253fb875e354eafdbfe466d0fc3ad58a418d479b2b8627"
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