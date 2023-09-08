require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.5.0.tgz"
  sha256 "fa82ec64096f8251f79e89e5a702892a6794df4fc4db70a4425b7cf096be464d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc86635f368e5959a671b3f45da64d8c2e2f86095eb6cc814137aa6b52af89aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc86635f368e5959a671b3f45da64d8c2e2f86095eb6cc814137aa6b52af89aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc86635f368e5959a671b3f45da64d8c2e2f86095eb6cc814137aa6b52af89aa"
    sha256 cellar: :any_skip_relocation, ventura:        "5fbb300743e5f6d4526629ffc678537a1ba0691a9c9eda0e095a1b243b3b2e2c"
    sha256 cellar: :any_skip_relocation, monterey:       "5fbb300743e5f6d4526629ffc678537a1ba0691a9c9eda0e095a1b243b3b2e2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fbb300743e5f6d4526629ffc678537a1ba0691a9c9eda0e095a1b243b3b2e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc86635f368e5959a671b3f45da64d8c2e2f86095eb6cc814137aa6b52af89aa"
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