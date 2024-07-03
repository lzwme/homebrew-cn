require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.4.0.tgz"
  sha256 "edc4ac35493f321e441ab63aa2cd04f5bd315edeaf0fad952b0344f176bbde95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc7eeca9ccf87681979158459f5550231ff2de078d290276b2f25f60f0f8ab9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc7eeca9ccf87681979158459f5550231ff2de078d290276b2f25f60f0f8ab9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc7eeca9ccf87681979158459f5550231ff2de078d290276b2f25f60f0f8ab9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "03d761f9a271b391e1b21ccb08f9026fb4330599ea0454a0dc43294f4e74588c"
    sha256 cellar: :any_skip_relocation, ventura:        "03d761f9a271b391e1b21ccb08f9026fb4330599ea0454a0dc43294f4e74588c"
    sha256 cellar: :any_skip_relocation, monterey:       "03d761f9a271b391e1b21ccb08f9026fb4330599ea0454a0dc43294f4e74588c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e113035e41180403e15e0ba2a8f98c498c1fb57ce18009573d6bf03ee9c867b6"
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