class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.7.0.tgz"
  sha256 "562ecf893f114f4f4b97073a82bd83b55b70e13e3a52c9ed26afa42180acce30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93642358bfee1a7aa7c0c09de9ec32e7428cb2c0de0e4c646fa7d7d646e4eb9e"
    sha256 cellar: :any,                 arm64_sequoia: "7edf076275f053cc25be20ada6b1714c9620c0c265b44b1d44eb8263edbdf737"
    sha256 cellar: :any,                 arm64_sonoma:  "7edf076275f053cc25be20ada6b1714c9620c0c265b44b1d44eb8263edbdf737"
    sha256 cellar: :any,                 sonoma:        "060963a20da7d933f0802d6a29bde82e27dec8bb32ed646a95b71979c5124826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3d245d463207ec3f6de23f075f1881360a2642df6c2fcbcd4e917f2bcdabc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3046f4648d4ac227033e1da3c748dc895f5d678b39b09f00df3759adacfde4dc"
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