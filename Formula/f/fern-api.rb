class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https:buildwithfern.com"
  url "https:registry.npmjs.orgfern-api-fern-api-0.61.20.tgz"
  sha256 "ea070c7bf1ef35f2fc399b4aece7b9b55ee04c9a04750f8ae8a1d3f8f6d73284"
  license "Apache-2.0"
  head "https:github.comfern-apifern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f40d345e63303cebf1f1edbe8c47ad82eb2a9a738395ec4bcfecb629b90b98f9"
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