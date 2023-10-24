require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.10.tgz"
  sha256 "427d3382ecd895f32331ae53b1a9d4c1e4a91fa65746cde1aacd004e0e64d900"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a4feb75caee8388d193312068d1b67b5badacc4a7fa73a131e035e33124cfd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a4feb75caee8388d193312068d1b67b5badacc4a7fa73a131e035e33124cfd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a4feb75caee8388d193312068d1b67b5badacc4a7fa73a131e035e33124cfd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a9bffc0c50338d47a172f86582bbbd6e0caa11f019aac87f0a578b7c56c39c9"
    sha256 cellar: :any_skip_relocation, ventura:        "9a9bffc0c50338d47a172f86582bbbd6e0caa11f019aac87f0a578b7c56c39c9"
    sha256 cellar: :any_skip_relocation, monterey:       "9a9bffc0c50338d47a172f86582bbbd6e0caa11f019aac87f0a578b7c56c39c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4feb75caee8388d193312068d1b67b5badacc4a7fa73a131e035e33124cfd7"
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