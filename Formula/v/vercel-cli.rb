class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.13.1.tgz"
  sha256 "49104fe0d5c87ec4500ae58a44076635a4d309fda4dc82283639ef2d3b84661a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f2ba7d0a5b8491f15b5b7ea78525586eff6a3aba17220c6f2147827e07d0762"
    sha256 cellar: :any,                 arm64_sequoia: "1844339fdb9db863ab0ac8055098c385bd22f508c874dad6630a840390b2abb2"
    sha256 cellar: :any,                 arm64_sonoma:  "1844339fdb9db863ab0ac8055098c385bd22f508c874dad6630a840390b2abb2"
    sha256 cellar: :any,                 sonoma:        "c818656e19ff297f10bd2ff23ec81af255db8dbbbaf71ab91e87a2ed6aa00761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e67c57666b728b3f065b98b3aeaaad26c3fc69042c5006dcdc5b19979d7d81a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ccbdd81d669ed53ff66fdea29c43d07aa643f4f34214b4b88945e1fdeadc8b"
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