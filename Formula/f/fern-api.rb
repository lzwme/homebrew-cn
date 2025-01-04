class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.19.tgz"
  sha256 "dd3dc3ee538bed29bf51393d0dac7a96575f161f4280ecdb9f2fc315290075fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd16080c167102e25e3bacf06f1825e59434478a5cbddaa3eeeac22446dc4e35"
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