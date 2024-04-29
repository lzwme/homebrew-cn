require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.56.0.tgz"
  sha256 "1f8e634c6e6b46ba1c7f20bacdc5b36c2272d00df02e88c43df8bbdc3876bf84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27bcc9cd927cab9acae0f59720026686817e0dbf4715bd2d860ffb304c980106"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f762fd84f0ee9f025bc68fcccf78460051da1fc3f0327521a7eee46e21c7e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c996413367bab1c7b857ac9299ae5bd12272e5225f2811c12e96dd52872585e"
    sha256 cellar: :any_skip_relocation, sonoma:         "13f0842cc944665c95ea352266b19fa60a66c34211bb49e938c65aad8101f2ef"
    sha256 cellar: :any_skip_relocation, ventura:        "766251a468bda596f1f78c41438c8a693ca4ca1c20582939f4c1f74b51c5bcf0"
    sha256 cellar: :any_skip_relocation, monterey:       "7e4f16180644043917f12df33c851ed71756c48cef7b36f57985ef0b55e965c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d99731ae5842dc9d5b09c21ffa279c91886ad59a3eb272f80ff0744b426298"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end