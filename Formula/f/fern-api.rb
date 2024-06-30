require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.7.tgz"
  sha256 "21c17fb8d0a4d9b351f35c7dff16ac4b64b78d6b657f192253bfc0b18bf4cc29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff47121b66c939a07833f9cb972dc5015a0a24acf8b378cd4e277c46e835f29c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff47121b66c939a07833f9cb972dc5015a0a24acf8b378cd4e277c46e835f29c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff47121b66c939a07833f9cb972dc5015a0a24acf8b378cd4e277c46e835f29c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff47121b66c939a07833f9cb972dc5015a0a24acf8b378cd4e277c46e835f29c"
    sha256 cellar: :any_skip_relocation, ventura:        "ff47121b66c939a07833f9cb972dc5015a0a24acf8b378cd4e277c46e835f29c"
    sha256 cellar: :any_skip_relocation, monterey:       "ff47121b66c939a07833f9cb972dc5015a0a24acf8b378cd4e277c46e835f29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb4af02f2bc5c194a5f340e7a8553e5d368274ef6521f1edd6fb97ac473d791"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end