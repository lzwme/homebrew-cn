class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https:github.comZhengqbbbcz-git"
  url "https:registry.npmjs.orgczg-czg-1.10.0.tgz"
  sha256 "8409c3e6656d5b860951615871fb546e809d0ecd12d67da0c2857b9720de75db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "104253e3fd6a1b91f68a65562239f3800225ef27a88ce5f093809c8b45eab1e8"
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