class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.0.tgz"
  sha256 "6a2dc24c0019965cde3d2cc1859b6264af938d7106d9001c0417fa998d9dbfa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36b7f8f0362d6bfeeff1f38b94ac8b4558f0c347b16714129224d0b83f33e1bd"
    sha256 cellar: :any,                 arm64_sequoia: "6bb40a3ae7f5ed7efcea6c5973f2534a99bb95913fbf2b4a67c0de19de458eb4"
    sha256 cellar: :any,                 arm64_sonoma:  "6bb40a3ae7f5ed7efcea6c5973f2534a99bb95913fbf2b4a67c0de19de458eb4"
    sha256 cellar: :any,                 sonoma:        "570527910e32481dd93441c97f8516b86edeaeca5a7c9351ef6835e4c3a83fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa6c471ae5bfdd33fe1cb3cbe89f4496ea1581fcf1d8865bbdbaeb52c3c39c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19316855406f1b34632799affd16efc8f3aef63e129a7ee9bd7d36142e381e2"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end