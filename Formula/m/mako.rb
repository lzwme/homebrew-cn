class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.4.tgz"
  sha256 "9dfc7f68bfbb8805523ec26a0e0b903078b3cc4b0762dbc5b91ab33441a4aa71"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16f90bd3327aa575ab007181d166f875c754cf08f0451b2642c51557841158fa"
    sha256 cellar: :any,                 arm64_sonoma:  "16f90bd3327aa575ab007181d166f875c754cf08f0451b2642c51557841158fa"
    sha256 cellar: :any,                 arm64_ventura: "16f90bd3327aa575ab007181d166f875c754cf08f0451b2642c51557841158fa"
    sha256 cellar: :any,                 sonoma:        "7324c564b585f680b0eca5736795bc3439f26a71915e43b7c636863499e84fa2"
    sha256 cellar: :any,                 ventura:       "7324c564b585f680b0eca5736795bc3439f26a71915e43b7c636863499e84fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5365d65726f1ec06d0d44ca98499a809b730872a944a857bc5e69b851642869c"
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