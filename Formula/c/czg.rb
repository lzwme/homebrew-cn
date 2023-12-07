require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.8.0.tgz"
  sha256 "3f19d2111df1e0551c5cffc4d3199e7b04412bd475353aac6911da069fd996ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fe171a429673b19b25a87e8d92a9d4882fb82280e5c8df6b32cbb08540365ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end