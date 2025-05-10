class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https:buildwithfern.com"
  url "https:registry.npmjs.orgfern-api-fern-api-0.60.28.tgz"
  sha256 "2e393d30e44bb563f8fbb729bc4f9943824f8dee3bf87fa57e9ef3aae56769f8"
  license "Apache-2.0"
  head "https:github.comfern-apifern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98d8363af4af8f6f8a667a41ccdbc7d0b7c35ce1355d8b82bea35e4d624751c1"
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