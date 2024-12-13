class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.9.tgz"
  sha256 "835def3935ec8dc31a955fa81e5c9337f1f1826ee54342105d05dc87f3307c95"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ded2a065d7b17c1d8cb56e8b722c6e3898dddaee2b361a132d5c49ef77593d35"
    sha256 cellar: :any,                 arm64_sonoma:  "ded2a065d7b17c1d8cb56e8b722c6e3898dddaee2b361a132d5c49ef77593d35"
    sha256 cellar: :any,                 arm64_ventura: "ded2a065d7b17c1d8cb56e8b722c6e3898dddaee2b361a132d5c49ef77593d35"
    sha256 cellar: :any,                 sonoma:        "393b3a43f0dd757ccc8d1f1f543e5a5cb25d456539a4c7c29bd11bd5672a5baf"
    sha256 cellar: :any,                 ventura:       "393b3a43f0dd757ccc8d1f1f543e5a5cb25d456539a4c7c29bd11bd5672a5baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7453d3965fa9c5f447cda5ce2200f77a5c239ed5c0c26be6d71d550563bffa"
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