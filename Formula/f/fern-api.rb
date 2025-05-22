class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https:buildwithfern.com"
  url "https:registry.npmjs.orgfern-api-fern-api-0.62.6.tgz"
  sha256 "39cdf2fe9e96e334cc92cf83e247d23c81b60424bba96d9b608c98dc78fc1044"
  license "Apache-2.0"
  head "https:github.comfern-apifern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "125a872038c1b18d7cb00953b7e3f534abd0d535ae96a5d51f221efb14215302"
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