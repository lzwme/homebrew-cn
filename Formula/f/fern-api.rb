class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https:buildwithfern.com"
  url "https:registry.npmjs.orgfern-api-fern-api-0.60.29.tgz"
  sha256 "b4be178d45ea8e6e7e4ce4a4d90585e1d8e8885f24747762e37d37189199d87b"
  license "Apache-2.0"
  head "https:github.comfern-apifern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8bafedbe279cbd50fa295639196246835d08d081e31adc64b7da2109a5902923"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    system bin"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath"ferndocs.yml"
    assert_match '"organization": "brewtest"', (testpath"fernfern.config.json").read

    system bin"fern", "--version"
  end
end