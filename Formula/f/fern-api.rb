class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.19.tgz"
  sha256 "fec4fca2a5d6132aa98d5dd4f9c52cb2b88ac8407bf4ef7e253a83976fcdec92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9908c1367d35bae2f5a806353a42b0aa31bab22d8af7a694434a14e6bf3674d"
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