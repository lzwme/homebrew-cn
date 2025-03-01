class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.5.tgz"
  sha256 "12beed7475cda4fd89ccdf4575bdb5ede73fdd62b7ee7be9d9d707574e8db7a2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78d5ab3bc543cf4d4835e371ed33e51c513cfc6df3e12652400d1541df510fbc"
    sha256 cellar: :any,                 arm64_sonoma:  "78d5ab3bc543cf4d4835e371ed33e51c513cfc6df3e12652400d1541df510fbc"
    sha256 cellar: :any,                 arm64_ventura: "78d5ab3bc543cf4d4835e371ed33e51c513cfc6df3e12652400d1541df510fbc"
    sha256 cellar: :any,                 sonoma:        "cdcb61f7b3e2c1d3e04c41ae0438f29a623558ac14cab0ecf92d314f8dc6e3a2"
    sha256 cellar: :any,                 ventura:       "cdcb61f7b3e2c1d3e04c41ae0438f29a623558ac14cab0ecf92d314f8dc6e3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a09fd1f7c43eb9d99543280f5a402482ad98653eae6633b0f77c47771ad7302d"
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