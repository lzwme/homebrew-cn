class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.40.0.tgz"
  sha256 "255c6f624b59c4ba861470f7253a2698c8c2a00daa7a8c34e0d3d76c720b6cc7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3363b4bccab54c94acbd4cdd0ff2d74a7ada548de27c6fdd23c5dd7aa1ffe1f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end