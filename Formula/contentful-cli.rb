require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.2.0.tgz"
  sha256 "1e35875c52be42deb3a353a96d8d68391114afe48d232a53fbbf83867324a44a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f90574e92ee0b63907044a6a610d06d93a3d16d5426bde6a17d31f2ce19078d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90574e92ee0b63907044a6a610d06d93a3d16d5426bde6a17d31f2ce19078d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f90574e92ee0b63907044a6a610d06d93a3d16d5426bde6a17d31f2ce19078d8"
    sha256 cellar: :any_skip_relocation, ventura:        "ec618f1ca1a371d499d5263f77050c4d1dacdb9e34d265082b34a9a9bebfdcb8"
    sha256 cellar: :any_skip_relocation, monterey:       "ec618f1ca1a371d499d5263f77050c4d1dacdb9e34d265082b34a9a9bebfdcb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec618f1ca1a371d499d5263f77050c4d1dacdb9e34d265082b34a9a9bebfdcb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f90574e92ee0b63907044a6a610d06d93a3d16d5426bde6a17d31f2ce19078d8"
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