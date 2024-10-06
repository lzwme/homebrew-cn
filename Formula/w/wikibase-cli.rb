class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https:github.commaxlathwikibase-cli"
  url "https:registry.npmjs.orgwikibase-cli-wikibase-cli-18.2.0.tgz"
  sha256 "ce947dbb62a51fdeef2b15d771d54183e9a94bb960bf28e8422e94153834bffd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9badf05131e66625614a1d88c29b89a24ac291595ea7a5285ee20bcc901b5bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9badf05131e66625614a1d88c29b89a24ac291595ea7a5285ee20bcc901b5bfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9badf05131e66625614a1d88c29b89a24ac291595ea7a5285ee20bcc901b5bfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e247597433dc7206739e654b82e0db4ae8ffa726e44414a5f028872459207f0d"
    sha256 cellar: :any_skip_relocation, ventura:       "e247597433dc7206739e654b82e0db4ae8ffa726e44414a5f028872459207f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9badf05131e66625614a1d88c29b89a24ac291595ea7a5285ee20bcc901b5bfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}wd label Q5 --lang en").strip
  end
end