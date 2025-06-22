class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.15.tgz"
  sha256 "8994e1ce578d8b9e7c3545d4f905aeb63dfd64af6048f580b6ba0f73056fa57e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87cab77e495660e3514e1686beb89a73cc98a7f424e60e02da8490a3fe277430"
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