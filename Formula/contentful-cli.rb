require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.27.tgz"
  sha256 "02c7092d700c963cc8744c558d3564b0241406239e1f81e3d993af3c8ca35e50"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c3deeb5d5d5ee2d753ecf56180754ca8a088f311d97ac6869642626cf100302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c3deeb5d5d5ee2d753ecf56180754ca8a088f311d97ac6869642626cf100302"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c3deeb5d5d5ee2d753ecf56180754ca8a088f311d97ac6869642626cf100302"
    sha256 cellar: :any_skip_relocation, ventura:        "d5d2abb6bf7862fdb183023c420af51bb17fe94ed3e619619fc2d8d9b76ca62a"
    sha256 cellar: :any_skip_relocation, monterey:       "d5d2abb6bf7862fdb183023c420af51bb17fe94ed3e619619fc2d8d9b76ca62a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5d2abb6bf7862fdb183023c420af51bb17fe94ed3e619619fc2d8d9b76ca62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3deeb5d5d5ee2d753ecf56180754ca8a088f311d97ac6869642626cf100302"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end