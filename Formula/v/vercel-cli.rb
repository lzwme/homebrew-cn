class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-52.2.1.tgz"
  sha256 "d4db7b87c8649594ce305ff720c57a91968fdf017add9466f28d51d0f4141991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "391f83c24edb5066bd82d791fd0df837a017277cdfe5b3e26bd1a74f56b04a14"
    sha256 cellar: :any,                 arm64_sequoia: "4730df7d0a9d2aa1b0d69459cdb610591ed034cb463231e61268d48f705de232"
    sha256 cellar: :any,                 arm64_sonoma:  "4730df7d0a9d2aa1b0d69459cdb610591ed034cb463231e61268d48f705de232"
    sha256 cellar: :any,                 sonoma:        "b40584d53dcba083a5aec2e0bb5b3c0b31b82963b4c84af26d73e5ab7f1b4d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c200025e13a75a3d13d931b28aed8fda9ff07be739394a5451bbc91e527e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647035e72d2eabd9b209ea9fe8b08595b20fdeafd7178504b5f7cc53950ab7c6"
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