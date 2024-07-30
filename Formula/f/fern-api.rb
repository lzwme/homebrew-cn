require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.36.0.tgz"
  sha256 "63c6c4fa76098b2f158e1b57d14c61b51b6d532270bc918dae0e25c0713c2496"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aa8c834d28f73f61a469909d22cadcd6757f3a31e2cde899c7ca7275eec9331"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aa8c834d28f73f61a469909d22cadcd6757f3a31e2cde899c7ca7275eec9331"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa8c834d28f73f61a469909d22cadcd6757f3a31e2cde899c7ca7275eec9331"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f1a80474433e8e48e854261efed1dd9adeff2caedb9419ed7caff668416ab8b"
    sha256 cellar: :any_skip_relocation, ventura:        "5f1a80474433e8e48e854261efed1dd9adeff2caedb9419ed7caff668416ab8b"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa8c834d28f73f61a469909d22cadcd6757f3a31e2cde899c7ca7275eec9331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0c0ebed8ace71bb1505e6cd4e95e5b5859a795b6a00616730338f8ea515e4b"
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