class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.6.1.tgz"
  sha256 "451af01d1cd85150bc4dcf18340198479014a786bc8576eb268c46ee06cc8280"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8f7bb17dda69c29a1bffad98bfa3c6d6f6f97de357f8ceec11b35070394efce"
    sha256 cellar: :any,                 arm64_sequoia: "b16c8164c33ec85367fe9a0ff704e08b1c375700da7c22191a71341ca43f1c81"
    sha256 cellar: :any,                 arm64_sonoma:  "b16c8164c33ec85367fe9a0ff704e08b1c375700da7c22191a71341ca43f1c81"
    sha256 cellar: :any,                 sonoma:        "5c29fc6e02079f862f7c5ce0426a0b472c3429e4c79ea91fceb9f93b8bb7db8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63d995c38ac9650818d840fa819b0e12616cb7e4c1658d4a7f7b1d3f23d3585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8daf2dfb940dd11b7426b4a71681a0f68a9114d6921bbe5f231c6b56f2bdaec8"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end