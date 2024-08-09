class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.0.tgz"
  sha256 "d425408272a92f34a8c41c6ca41afad2ec37739244723e89a1d1c5f2caa8591f"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "29796abe1fa7ff3b6be2a42f7d550887689cf2a0f1ecaa428285d8fe1099096e"
    sha256                               arm64_ventura:  "78a6bd11a6e15939c7eadaae8e4a50a0ee5ec18796296dc9a5404f0c22b64322"
    sha256                               arm64_monterey: "231bd0c41f31f1002140403b375071391e20e9ebfbf750af3f2914b3b49e8711"
    sha256                               sonoma:         "230cfee0a3189b5845463f8531bcc270c2b97ca74d509e50aea4250b32b09a48"
    sha256                               ventura:        "990c9f0546742bb06272fd270a07fcdd1a366a11c12def7dd868e33d580a40ad"
    sha256                               monterey:       "c9e3b0bd1a07a0daa3ae9d242b52df9fdd0dec4ce75ca59fb8f3d2afff23f0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c25fc5a4c2d6914862b6d8d033602fd88fd07dca9289641988fb7996af6c3bb"
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