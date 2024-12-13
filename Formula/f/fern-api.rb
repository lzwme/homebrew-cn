class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.1.tgz"
  sha256 "b60022043b13075960cbafde26abe0366bc86e138d6918b120ce0b8897424d90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8482a3e0b1d0c929f800fe6dca191504ef8da85e668bfedc7b092078b3a2f2a0"
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