class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.5.tgz"
  sha256 "42d5cb819100f4eb646b40a5d089c844a2d828ea9fd3d7cacba4c4c914c8deb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "268f5faf26f92df7230e32a9f1165a5605778812852140d5aacf87c532f33e0b"
    sha256 cellar: :any,                 arm64_sequoia: "86fa150c23955ac7eafaf01a7cff468cb49718e8beb5c1e90428cdc523445cef"
    sha256 cellar: :any,                 arm64_sonoma:  "86fa150c23955ac7eafaf01a7cff468cb49718e8beb5c1e90428cdc523445cef"
    sha256 cellar: :any,                 sonoma:        "07f10e37443e4790983359d65fb769fc9369be83c9138b6b039c3b4cc1f5b6af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f1666bc21e6bc1551b6c4b0a3930dc71653572f53a7d67e8bd8d0521cbae8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a33fd04a0653143a5c4a7de76f834c50b5f2d8655765d62569049ba7a2ef7a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end