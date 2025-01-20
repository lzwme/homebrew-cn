class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.11.tgz"
  sha256 "8c91981adf6ffd3bd2c66cb72f750f783e6d33e0ae2ee5d00938aa9e7bba189b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "060892c72cd10778a46d1963c44141820faa0fc7365aa484f648a94016c6a20f"
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