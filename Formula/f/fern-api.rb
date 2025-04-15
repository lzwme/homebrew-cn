class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.25.tgz"
  sha256 "3bbd2f19620b80580c56129663cafacf6bcc9342847aab09210bdcdc537d2bfc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "362d1309c68cb9b94d3a0119a38b1c2029d67ebd0cbe9e694b6df22b8aba96de"
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