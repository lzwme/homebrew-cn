class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https:buildwithfern.com"
  url "https:registry.npmjs.orgfern-api-fern-api-0.60.19.tgz"
  sha256 "48197891c9df200a7c5b1aac4c6281829f932975f9153ae41f9bd2eb3c25fe08"
  license "Apache-2.0"
  head "https:github.comfern-apifern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f6f17cd6535407616ab35f2bbabe9c6939c36a967364409abdf0ab85c6b57a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    system bin"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath"ferndocs.yml"
    assert_match '"organization": "brewtest"', (testpath"fernfern.config.json").read

    system bin"fern", "--version"
  end
end