require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.4.0.tgz"
  sha256 "7c3a4de01c07e6a2bb93dfabca32113dd71817fe30501ada7d86c7e736535972"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "3536f5dc779f2f229c2f28ef3a6633991c475c915c7cff7e71b5f69ee0801041"
    sha256                               arm64_monterey: "eaacd6c061fe38072bbf2f9252580739a9350af837705d92f2f7a04842b686a2"
    sha256                               arm64_big_sur:  "0e3513695f38222bee7e3cbd12a42cc0b3dde28e18671c0d0c0864c45a09c131"
    sha256                               ventura:        "b03ca227ece88c8f5eea7d1e4aba83e89a3289f2aef79379c386ab64f4cf1f56"
    sha256                               monterey:       "69368ec299cac5956db664ae65886c756fff857856e19016d57c08194fd18b55"
    sha256                               big_sur:        "1c8c54eb7554c6503571dfa2a7a3c0530e9e42731f26321919bcdc9bdcba3a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63b18b1d415c6f63adeb5794a27d6fbea35136083c8663391303d87be494951"
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