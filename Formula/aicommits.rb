require "language/node"

class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-1.8.1.tgz"
  sha256 "a595b0451e358b4d140a62de49b9ff00fe7d607ccef3f2d9f866cf411c915ed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bfae9925da54ad60154b08e60f0ef5251325470d0c0f11c01a027179f2f5264"
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