require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.1.41.tgz"
  sha256 "eda853498c788c3a5c9d2df76025769389aad7db2b6699e5cbc0426db7fadb99"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6829122bfd85d1544213d54b392c824a21c780b6c6e0c3faadf1c59263d978b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6829122bfd85d1544213d54b392c824a21c780b6c6e0c3faadf1c59263d978b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6829122bfd85d1544213d54b392c824a21c780b6c6e0c3faadf1c59263d978b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cbb65c714397324393d154ded7e36fc844e05fb7b4ce8001137326adde79661"
    sha256 cellar: :any_skip_relocation, ventura:        "9cbb65c714397324393d154ded7e36fc844e05fb7b4ce8001137326adde79661"
    sha256 cellar: :any_skip_relocation, monterey:       "9cbb65c714397324393d154ded7e36fc844e05fb7b4ce8001137326adde79661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6829122bfd85d1544213d54b392c824a21c780b6c6e0c3faadf1c59263d978b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end