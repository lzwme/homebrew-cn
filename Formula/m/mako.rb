class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.9.tgz"
  sha256 "d3bd02daf785daf4ad0bff12424987cc76319489b3b2be447e125c0e1b0ce447"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "770f8d1c5c4e0b1c5cdda1aacb31aba6587c2e687ccb84abae7df19d00fa1642"
    sha256 cellar: :any,                 arm64_sonoma:  "770f8d1c5c4e0b1c5cdda1aacb31aba6587c2e687ccb84abae7df19d00fa1642"
    sha256 cellar: :any,                 arm64_ventura: "770f8d1c5c4e0b1c5cdda1aacb31aba6587c2e687ccb84abae7df19d00fa1642"
    sha256 cellar: :any,                 sonoma:        "4a4f134aef7d86024077f008815b5b2d892f1c8d3370417d4e03204fcf656a3b"
    sha256 cellar: :any,                 ventura:       "4a4f134aef7d86024077f008815b5b2d892f1c8d3370417d4e03204fcf656a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b577c4f687582d5b727a0b73968db0dbdf6924fb621d468a360806b11962917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e66d9dd5a51f618e24266571be8c7dc731058e0048a5315aab730cdedea9e84"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end