class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.18.tgz"
  sha256 "a6a8472b590f22efc2a318252a3251a59ef703970a72e6bcd00d2d28fbd03804"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aeba78e2d03ab66ca8e849223f34182bfe617a13f4e28ffe0609d8b88662208b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end