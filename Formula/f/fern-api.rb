class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.9.tgz"
  sha256 "348f9f43a21a84498a756be949681ad3039f882e50326e6434bd76ef44f519bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67d94312128708238e695b4ae444f8b1736dde877a453d092683f388a2cfa483"
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