require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  # netlify-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-13.2.0.tgz"
  sha256 "b8e1570e784ee871d4b623c58bf725f4cf902f674ab248629da2cbe6ffbce894"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "d22abcf6160dc6c78121cc63eb3aa9a4585434eb7934582f273fcb9ae01db997"
    sha256                               arm64_monterey: "d5de02546634bf6825e82c165bf08e320d8b74bbda0aa3aa53a7c04346462a24"
    sha256                               arm64_big_sur:  "ee4646bc50b83df39520ba2e7cf2ad2ba4bc02058af15470b126ba052505e5e9"
    sha256                               ventura:        "9fbc6d7457ef185c0a1b208f9cb5c9a00390fafc9b0fe7463ef730e223458d1e"
    sha256                               monterey:       "68c1840850d68e49d8ec19240979bca3cbc40f8e80da8d99b4c3a88c33d8a8e0"
    sha256                               big_sur:        "1f0ed3d0ace6462263f15a7e068de3f9db82e3b7920f26f0813fa7f0a83badfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281e9c975148323ff2c30c781c9783ff18e1504819ee6baadd2d7778d2c73aec"
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