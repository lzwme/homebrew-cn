class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-53.1.1.tgz"
  sha256 "456d798a141cce332dba7e5575287a8c453e320daebe8646e1709487b7220d50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86ea62390e5de1c7f9351c0463dd1c7df58e4acf0e3d38636d73891253946509"
    sha256 cellar: :any,                 arm64_sequoia: "8fa87371d8084033f7946316a90afa0688593406187d9d5e7a4512ff569a91f8"
    sha256 cellar: :any,                 arm64_sonoma:  "8fa87371d8084033f7946316a90afa0688593406187d9d5e7a4512ff569a91f8"
    sha256 cellar: :any,                 sonoma:        "9fb83191eebdb94855f5c28c9a243574881ea49e199f2c083785f55149653a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "606aa55d0d1528741fd0c1ca4c6d330e49aae54ae993350736229854231d308e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16082d3f0d7b65a7e023a5904ed55a84c5f65dd2fe96b0cc021da55cd45c0ea1"
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