require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-14.4.0.tgz"
  sha256 "140c1e94e3f7d2bed45df32e355374a32cd7aa1a4e3ec17b442b5a3bf97ae4f0"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "e74beb03e151bda275d4fe4d2f856982bb9b511c4c3cbdc1d54d1281002e12ab"
    sha256                               arm64_monterey: "e28f5716883acfa5e3fc56f73d4f7274c00b57f255a93c3593314d68a5eaee2a"
    sha256                               arm64_big_sur:  "9117440493fc42bba7e1b00bdddff93f83aea3fd4890ce5945d4e766e169013b"
    sha256                               ventura:        "e04efa963977455404f0aadd5c15124c16e4b978fafa685318cb9d54e5bbd7ef"
    sha256                               monterey:       "c964ee935f0585c13758c697ea765b397b5da0c7a51bb193c47cf01d33799a26"
    sha256                               big_sur:        "dbb74627cf3180f8dc1908dbb57517f56bf87ade44391661f4e6aebdde6efbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3800acca0ec27c9671891bf4a4257fdbce6e4a7089d37d7491a84bcd33b22dc4"
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