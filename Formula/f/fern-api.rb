class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.0.tgz"
  sha256 "1a4b6e9f86c750d17184444eb9c441adb0ae1665d685d37c27ca3c41a5efc0fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea15ac578022b1d14a6f81d9d90bede47156ca3e351d6fff4d73e7b1ca5f667f"
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