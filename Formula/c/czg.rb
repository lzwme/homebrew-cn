class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https:github.comZhengqbbbcz-git"
  url "https:registry.npmjs.orgczg-czg-1.9.4.tgz"
  sha256 "d005cdff971561e70fe64d615ab67e60d5eba0e8f9dd8994fa22b54f861f9b47"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a3347a508d4da68d32e5b6ef0c837f2cbfade314eb131f94dd944fb9e9a6c07e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}czg 2>&1", 1)
  end
end