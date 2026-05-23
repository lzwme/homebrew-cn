class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.3.0.tgz"
  sha256 "2403bcb06c1117b725653e48a85b7db991684fa3b68330253940a37d47c251a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d05c7b64565ce434c30cd248799beb51b26a04cf7fb1075fb320f23830316147"
    sha256 cellar: :any,                 arm64_sequoia: "bbdb5814d7abf9b1c065acd9be9a25f03b9c1f99d0e7283e21c5adfef7ec7bf2"
    sha256 cellar: :any,                 arm64_sonoma:  "bbdb5814d7abf9b1c065acd9be9a25f03b9c1f99d0e7283e21c5adfef7ec7bf2"
    sha256 cellar: :any,                 sonoma:        "7a1ececde4e0ef724cbd93d83efd0bc062cc29df435e71e8797e59994a9cbbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f8c2144dfc7b851f2e6b0e770f5622e070950c7368c4fc658f3f384d7dc86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc67db2022d01f76db316f9df4fb919c6ca52a794155ae137c8e20e59dd5fac3"
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