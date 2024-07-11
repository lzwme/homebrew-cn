require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.22.tgz"
  sha256 "85058387119d75763933472477c0c24276bdda8ec74c59c06eb7c647f01df2c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a74a1b5287b124257e02059c0fb54f85ff17ebf66908d1a9c94ee77fe7535a4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a74a1b5287b124257e02059c0fb54f85ff17ebf66908d1a9c94ee77fe7535a4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a74a1b5287b124257e02059c0fb54f85ff17ebf66908d1a9c94ee77fe7535a4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a74a1b5287b124257e02059c0fb54f85ff17ebf66908d1a9c94ee77fe7535a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "a74a1b5287b124257e02059c0fb54f85ff17ebf66908d1a9c94ee77fe7535a4a"
    sha256 cellar: :any_skip_relocation, monterey:       "a74a1b5287b124257e02059c0fb54f85ff17ebf66908d1a9c94ee77fe7535a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47c71823d92295069c4491d1adfb71647a21b95874b1163f7dbb89f9147bdde"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end