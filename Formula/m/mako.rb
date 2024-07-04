require "language/node"

class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.4.tgz"
  sha256 "766b99d3116941f67f19cb055c8817c37f52dd1cbeb3b8953e64a3b085a1c38a"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "8c345f403df060973f1e2674bf73b889c348394fecd1417642f99f1999709cca"
    sha256                               arm64_ventura:  "35a0b885b2db33012e6a3192f87739386eb02bf8d48c0c32db69061c9b867f00"
    sha256                               arm64_monterey: "8f682a3ad47087344a75cae0aaf4e34e618c8b7205a369b30453ed9f6ffbe726"
    sha256                               sonoma:         "8322466e39c872f1cdaf8e249aeada0afdfe7cd76e5b96db784ed1fecce70218"
    sha256                               ventura:        "23ed55ec94f08d472852469fb4059faaad20f1798256b46d3d83c03cf8efea95"
    sha256                               monterey:       "8d1bae99b177bbe20e5656c0096edba964e51c2276a4c142921d6c79e758d28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87a2db330372c4269876f4cccd4914bc0dd798db69f7ecd388aa170b6d30efd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end