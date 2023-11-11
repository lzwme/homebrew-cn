require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.0.0.tgz"
  sha256 "f95dd23d6facc4ce8d77543effaf7ae906146b55d516d8015f4933c357960283"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d53f5806b99de932374aebf51d076b8a75876e721e68d79c2f7847ad407044bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d53f5806b99de932374aebf51d076b8a75876e721e68d79c2f7847ad407044bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d53f5806b99de932374aebf51d076b8a75876e721e68d79c2f7847ad407044bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "686b3ddaf1dfa8ec64bdbf5318a4f88f1373c1d4dc706a722c7f505b7f5111c9"
    sha256 cellar: :any_skip_relocation, ventura:        "686b3ddaf1dfa8ec64bdbf5318a4f88f1373c1d4dc706a722c7f505b7f5111c9"
    sha256 cellar: :any_skip_relocation, monterey:       "686b3ddaf1dfa8ec64bdbf5318a4f88f1373c1d4dc706a722c7f505b7f5111c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d53f5806b99de932374aebf51d076b8a75876e721e68d79c2f7847ad407044bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end