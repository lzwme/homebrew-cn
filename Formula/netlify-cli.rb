require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.3.1.tgz"
  sha256 "d820818b9b405fd3efebd8a314ed5d4f9e6466fe5e0460580f49bcdb949875c3"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "4959327c88b531f3ca4ebc1e3c199042c8f9f933886b3d7ec0a8be26fe7db109"
    sha256                               arm64_monterey: "58b8ff7f217df0b80d4de6baeae9fdc6df578795d0b8679f75d1bf1fe1a3fd0a"
    sha256                               arm64_big_sur:  "772b8c27ee4bae550f10a6c2155d08879c3c7dac66cbbaa58d894b2123693c33"
    sha256                               ventura:        "0101f1e2413a27678dc738a15ae0185778c48f9295b7faf7f252ead9af20a430"
    sha256                               monterey:       "ac72007e6cbdf07e1c52fd411a0bf14108bddea20bffb116e83f5260cf84728f"
    sha256                               big_sur:        "71b1962f1147a380522275e146ec92350478b0a00615e50b7f5cd828f6402b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa2379c617039f113a4afe837d823a7529f7a67c43d521b5672e23206725760b"
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