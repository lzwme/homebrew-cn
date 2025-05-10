class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.11.tgz"
  sha256 "e01d3901af50d122a82f8249211978725ce6e0b7f4aeb3bfb3cfe0786840c5cf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7838b2a47fd447410185327ca1fcb2674c5062ff72843de812089e096f31a9db"
    sha256 cellar: :any,                 arm64_sonoma:  "7838b2a47fd447410185327ca1fcb2674c5062ff72843de812089e096f31a9db"
    sha256 cellar: :any,                 arm64_ventura: "7838b2a47fd447410185327ca1fcb2674c5062ff72843de812089e096f31a9db"
    sha256 cellar: :any,                 sonoma:        "4581d14ee9138dfd6312cbbc683ac479cb036d2f52adcab69d653c848d59a5a6"
    sha256 cellar: :any,                 ventura:       "4581d14ee9138dfd6312cbbc683ac479cb036d2f52adcab69d653c848d59a5a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5070fb1219090d4b8592d89e7f998a75dd2bcaf930f643a4e3289382ec6685d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405f30504e483614212ece1383f4145ab8e7f812b397ab2ac2541e20726293a2"
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