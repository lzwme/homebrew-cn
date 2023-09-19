require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.3.5.tgz"
  sha256 "cb2227cfb8e298e2ca3b611866b5d7abb2d2a05ff8b36646e9db18e6c52e7ce3"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "66cee279293d295f3d1795e1e2e0f1fc647cfb16c74152724a3ca9d81c1bf2ec"
    sha256                               arm64_monterey: "a81ef47cced1ecbc89ecfbe63057175b2019a54aafec0edb3e7a5c30b4dd3d92"
    sha256                               arm64_big_sur:  "33a68ad991a50db23c88bc4d12e381184f2ac45c4b27338cfc6ec34ade27512b"
    sha256                               ventura:        "b6ae7c6786893879b650631c96ab6f0998e83066a13dd736eb33802a452e58fa"
    sha256                               monterey:       "59173480d727c0b3898af230114a2aa4185d9832d31954cd06a91f8572019d64"
    sha256                               big_sur:        "22dc0daea5aa706f90c2c4f91b13ff8e03c92fdcb35092c9d9e774e5dedaaac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "119116710b46c026eb061e9f484f3ae8099e17332174fecaf5f405a2ca7d22f5"
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