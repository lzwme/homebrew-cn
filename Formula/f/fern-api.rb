class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.18.tgz"
  sha256 "84da6cb86d46ea68f812dca25cfa2ae35f67deb0d924b1e0750a8ab611c1a200"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "651f8f8055202219a96ca243503f383b7324f3140a7b42e630fd2f1009613877"
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