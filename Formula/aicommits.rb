require "language/node"

class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-1.10.0.tgz"
  sha256 "e05e16b30d5ef6e3233715444284a48d72b48b66c4ab4eb824a3169029dcb1e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67d86d9a7fa29ec84e423c1baf613ec304785d0eb5c8749a4971e76ecb4471cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output("#{bin}/aicommits", 1)

    system "git", "init"
    assert_match "No staged changes found. Stage your changes manually, or automatically stage all changes with the",
      shell_output("#{bin}/aicommits", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "Please set your OpenAI API key via `aicommits config set OPENAI_KEY=<your token>`",
      shell_output("#{bin}/aicommits", 1)
  end
end