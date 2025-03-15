class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.21.tgz"
  sha256 "7ad73e7ec9858f7bb87fa4fa6ed26ebd784c14113bdf4cf0b730e56dfd741699"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c4e02ec982dbf18305e239ebaeb2f7a3df6c5035ca7e5743a5333cf6e46b865"
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