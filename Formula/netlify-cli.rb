require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-14.1.0.tgz"
  sha256 "35e33957e5504c3e0696ebfdd9a8c72fcbb5ed5e8f2701412d3e18aacea1fa14"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "579ae6d36e8e0ed163ecbf2a88f1eef9a2fc2b4368b083e3c7e44afd04ea3b51"
    sha256                               arm64_monterey: "3eda38dc649e838ca0ad5408218c8ce9861e53261e97567d7cd18bda0a8e9b5e"
    sha256                               arm64_big_sur:  "ca616e7db39d2d3c9adb9959b02fe071345dee4ffece335d5990a3be39c105b8"
    sha256                               ventura:        "9c3c6cc7cce1b7917cc90d59938921a11af59279c6a618c058f428ce4f64c7a9"
    sha256                               monterey:       "58403c4ff7c2fe15dd701566c457ad1d80829147cbebe962781862515f909e20"
    sha256                               big_sur:        "5ab3b2469dee7ba3a248ffc1685507be793b156d8deaf7c62750aa2ed582d7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ef54f7f29cd505875e4affd60e0b394b039887094c6d423406c7d838005342"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end