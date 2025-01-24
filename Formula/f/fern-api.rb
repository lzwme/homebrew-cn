class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.2.tgz"
  sha256 "3bfdc1a055930aba0e6e616ad0631a0759b42443207d45800971ea9cd36c527e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcf1dc317a72c2474dabb0ef79deae2b9b5a2ae67e72d72cb5d142602d2f4091"
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