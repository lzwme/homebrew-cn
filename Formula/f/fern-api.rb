class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.14.tgz"
  sha256 "a44298183d353928224459488a95eae15e9828a5bafd58a76305f425cde30b9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9326826e17023e2b94f4634177d8596401687a210f8e8e7d8a664bb0ad47d2c8"
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