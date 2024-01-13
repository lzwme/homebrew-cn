require "languagenode"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https:prettier.io"
  url "https:registry.npmjs.orgprettier-prettier-3.2.1.tgz"
  sha256 "f630ade698d30aea7862c6ae9804c1ffb93b1de51480f0965f0aa459dd576f91"
  license "MIT"
  head "https:github.comprettierprettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90ff84d6d22afe4d636f6c43510193f4bd20fb0c1dc89931a30a8493f116edfe"
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