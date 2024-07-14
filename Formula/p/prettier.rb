require "languagenode"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https:prettier.io"
  url "https:registry.npmjs.orgprettier-prettier-3.3.3.tgz"
  sha256 "2f1ecb0ab57a588e0d4d40d3d45239e71ebd8f0190199d0d3f87fe2283639f46"
  license "MIT"
  head "https:github.comprettierprettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0744f89a63b2e4a723402ec8f6e57fea7e71854ba3c2bc0049fee0eaddc97a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0744f89a63b2e4a723402ec8f6e57fea7e71854ba3c2bc0049fee0eaddc97a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0744f89a63b2e4a723402ec8f6e57fea7e71854ba3c2bc0049fee0eaddc97a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0744f89a63b2e4a723402ec8f6e57fea7e71854ba3c2bc0049fee0eaddc97a5"
    sha256 cellar: :any_skip_relocation, ventura:        "c0744f89a63b2e4a723402ec8f6e57fea7e71854ba3c2bc0049fee0eaddc97a5"
    sha256 cellar: :any_skip_relocation, monterey:       "c0744f89a63b2e4a723402ec8f6e57fea7e71854ba3c2bc0049fee0eaddc97a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "965733cf8e1e8e6bc22367d92eb1e7e93c1c0c373e0d9044d82249f62c28499b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end