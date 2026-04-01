class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-3.1.0.tgz"
  sha256 "9d3076be57328572c1628fc1edbde2874ee8c5354b81f7d613aa491938955778"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ca0efdeba790c4b7bca1fca460ffc4d47f20b29594092576cf864d2bdc0ea8c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output("#{bin}/aicommits 2>&1", 1)

    system "git", "init"
    assert_match "No staged changes found. Stage your changes manually, or automatically stage all changes with the",
      shell_output("#{bin}/aicommits 2>&1", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "No configuration found.", shell_output("#{bin}/aicommits 2>&1", 1)
  end
end