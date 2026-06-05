class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.9.0.tgz"
  sha256 "7b0e3612683a61efab783c5ec8592d8263a9eef6cdf276fb6373c2ee941aba73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "777e67c62b19f813ab7c24ce8b8ec6068a371ccd06bb4a9ac89688f5d61520d9"
    sha256 cellar: :any,                 arm64_sequoia: "306fed4dcfd465c5781e8406a278007eb078d6dce3fa217f383ab94127a9a603"
    sha256 cellar: :any,                 arm64_sonoma:  "306fed4dcfd465c5781e8406a278007eb078d6dce3fa217f383ab94127a9a603"
    sha256 cellar: :any,                 sonoma:        "f291e529011fbed19702a96bcd9fdbfb39fcb9154ae43a4d1cd004f0c97e970e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae5592a40ddbffb5847d6d6927c0022d1af7ab519cc39ac17841fbc4728dfb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9539fd8e07e86299cf285724fea8e62ef0867b78f217d066d44c0eeb36342a91"
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