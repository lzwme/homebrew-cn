require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-17.0.5.tgz"
  sha256 "3264e6ae845103c4f611be86a5dada6e6b3f105d16b28f00754365b3ad8671b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a32ddeb87aaf17d3280110c611f784b99ae9d2a3aa2c6f8687f834b515913136"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a32ddeb87aaf17d3280110c611f784b99ae9d2a3aa2c6f8687f834b515913136"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a32ddeb87aaf17d3280110c611f784b99ae9d2a3aa2c6f8687f834b515913136"
    sha256 cellar: :any_skip_relocation, sonoma:         "76d97acd1640e0b510927943921ef7cd390b8bfd136750e0d56ea7832cbd20ce"
    sha256 cellar: :any_skip_relocation, ventura:        "76d97acd1640e0b510927943921ef7cd390b8bfd136750e0d56ea7832cbd20ce"
    sha256 cellar: :any_skip_relocation, monterey:       "76d97acd1640e0b510927943921ef7cd390b8bfd136750e0d56ea7832cbd20ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a32ddeb87aaf17d3280110c611f784b99ae9d2a3aa2c6f8687f834b515913136"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end