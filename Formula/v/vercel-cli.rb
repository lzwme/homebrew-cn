class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.4.1.tgz"
  sha256 "375b30d1be8b1b98d5fd4d3293b99d83d0b256f56584182f79955bb95c6f844c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e34c00cde879c73fc6e759e3f0bc01af90e2a954d6953e658aa83946008d15ef"
    sha256 cellar: :any,                 arm64_sequoia: "7d40264552c852a95723de629058fe1f297136880ff919bfb30088587048c365"
    sha256 cellar: :any,                 arm64_sonoma:  "7d40264552c852a95723de629058fe1f297136880ff919bfb30088587048c365"
    sha256 cellar: :any,                 sonoma:        "b994f8c783b1f84d33852c5a673dc582e8b6095f52a7deaf4d8d0a4d82533328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f6722b9104f2f4df216b5b9e6b6aea5423526dc301b315440647f9a4a0751a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1169f82c9af69e8847efa3b8c7426ad62e94b3527ab244aa63ffb2c150ccd34"
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