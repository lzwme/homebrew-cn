class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.5.tgz"
  sha256 "1f1b45261a7c6dcc5647de6365e6269cfa7be2a4460b7d49b01b28a6c1170865"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23b7d7dd53e0797e91eb9d90053ccde4ed8f6f44d809432b5c7d7fb83133dae8"
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