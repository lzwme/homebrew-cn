class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.12.tgz"
  sha256 "b6ad1e8e5ebc824ee0608028957e6d63c1270a5f90a9bdbd9f23ee07e22dd7db"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fcbb2f404bb9a76327923e9f61b5df7085d06461737a62f1effbde9a902517c4"
    sha256 cellar: :any,                 arm64_sonoma:  "fcbb2f404bb9a76327923e9f61b5df7085d06461737a62f1effbde9a902517c4"
    sha256 cellar: :any,                 arm64_ventura: "fcbb2f404bb9a76327923e9f61b5df7085d06461737a62f1effbde9a902517c4"
    sha256 cellar: :any,                 sonoma:        "0f6f14500e2d16bf4cbf0fe3da35606dccbc60203038dad94ad0f1967b85e00d"
    sha256 cellar: :any,                 ventura:       "0f6f14500e2d16bf4cbf0fe3da35606dccbc60203038dad94ad0f1967b85e00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13d6f509fbcf24f177ececabdbd5401d8ea2d5090e873209db9c71acfa9fa81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4519e14e650193e11eddcd598cb65dd16d0dfa8c4cd83ee1428de8637f100c38"
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