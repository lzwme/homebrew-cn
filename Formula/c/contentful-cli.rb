require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.1.42.tgz"
  sha256 "e1e5b40c6eac1e7dd69d6bf4bec8dbca05f4d5bb7315456fafc53772455f70dd"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b02c17e4d886e6cfd5bd770b996902b9276d77bbb4cbd3bc3fc5ad279434515"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b02c17e4d886e6cfd5bd770b996902b9276d77bbb4cbd3bc3fc5ad279434515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b02c17e4d886e6cfd5bd770b996902b9276d77bbb4cbd3bc3fc5ad279434515"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c67ec287afc87b3fed97ae2dc659febaee8dd1823d6e0466218b7a58e4d4c09"
    sha256 cellar: :any_skip_relocation, ventura:        "9c67ec287afc87b3fed97ae2dc659febaee8dd1823d6e0466218b7a58e4d4c09"
    sha256 cellar: :any_skip_relocation, monterey:       "9c67ec287afc87b3fed97ae2dc659febaee8dd1823d6e0466218b7a58e4d4c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b02c17e4d886e6cfd5bd770b996902b9276d77bbb4cbd3bc3fc5ad279434515"
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