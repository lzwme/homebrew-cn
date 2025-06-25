class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.20.tgz"
  sha256 "cc012cc43acb16c7c9d12e45defeca63f5d2497e34a23fcdf9c5599d138b558d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d23a22066f194c0a143c6735ed7be2e76282b5a5b5d9f8e6fd1cb297b97de559"
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