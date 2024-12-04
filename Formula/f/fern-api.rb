class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.45.2.tgz"
  sha256 "721c59542f509cf3a4664856d1672436be708a192dc60cce94a11dbae14bc71a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22ddb0d8fe5726c4472f8dd193a8745de337fec039ba8bce23d4921ef812b47a"
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