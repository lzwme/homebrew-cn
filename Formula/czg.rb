require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.5.3.tgz"
  sha256 "6668429a6345f8dfc1b5ee7b3835b3865f763a84514d32f74a7547c9304a8ad7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50f2e0f6063b00b8785dc025805cec0bfa0298120529d258a70687cdc7af6e6c"
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