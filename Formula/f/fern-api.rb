class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.1.tgz"
  sha256 "6ccda61d07ee9e1739c7706a0f597636c5f8aad257bba65752fd43d03c77ad05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c631f5a65c74393a55e7f8e1bb6852bedeb7df07fa2825c8cf19d9abf961dc7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end