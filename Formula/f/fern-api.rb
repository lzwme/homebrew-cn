class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.47.2.tgz"
  sha256 "99bf09b43d2e2dbfcf75d36c910b6b978ff2572a579e45dfd33524d5e86299cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "372a7c5ecf62e8e3cd91d3d11980f433083463e049e0594e3e8315d258cfff9f"
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