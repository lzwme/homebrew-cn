class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.11.tgz"
  sha256 "6b7ac69e551070d8503fe9d7fdcc2b701ba13471b772d660f6f457cfc6c0695e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6282edd8cedd24df9439ecd3a254d496e29f02d210eed185bf44b74e2ecfff45"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end