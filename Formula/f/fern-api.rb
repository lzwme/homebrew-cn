class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.22.tgz"
  sha256 "735ac4fe937b3b74a394a9067edda75ed1a6f0c100305c6c750c9c6249822ff4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae18331d3a0587b327742210ab99c59dda1d73ee1e435356f8e0eabc4b173aaf"
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