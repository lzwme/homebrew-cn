require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.23.tgz"
  sha256 "7482b39eee50668a23ad57d532ec5026b8b09c5145c359883af66e905894e80c"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21f0bb2f3c0c5117ca236d272294bb2b29ef2d06a49e5d0a879b187ffb34f320"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21f0bb2f3c0c5117ca236d272294bb2b29ef2d06a49e5d0a879b187ffb34f320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21f0bb2f3c0c5117ca236d272294bb2b29ef2d06a49e5d0a879b187ffb34f320"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1f44cbe65305ba6722daf8296ac9ec16b08e103966fcc82a93786d3b9b88c86"
    sha256 cellar: :any_skip_relocation, ventura:        "c1f44cbe65305ba6722daf8296ac9ec16b08e103966fcc82a93786d3b9b88c86"
    sha256 cellar: :any_skip_relocation, monterey:       "c1f44cbe65305ba6722daf8296ac9ec16b08e103966fcc82a93786d3b9b88c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21f0bb2f3c0c5117ca236d272294bb2b29ef2d06a49e5d0a879b187ffb34f320"
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