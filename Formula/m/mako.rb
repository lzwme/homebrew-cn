class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.14.tgz"
  sha256 "bcb53740ff9290d59e48e6762d2bb4e1f42cd76f3832d8c6b3edb1e77e22e83b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da38c10d40cb6d1bcbcf9bf8372a317cd6e37624ca367b2890c8c16e47232b36"
    sha256 cellar: :any,                 arm64_sonoma:  "da38c10d40cb6d1bcbcf9bf8372a317cd6e37624ca367b2890c8c16e47232b36"
    sha256 cellar: :any,                 arm64_ventura: "da38c10d40cb6d1bcbcf9bf8372a317cd6e37624ca367b2890c8c16e47232b36"
    sha256 cellar: :any,                 sonoma:        "4be1ca5b65c2d9e04732df0d9a158adaa2b0c84ac56006c810a7d676240be22a"
    sha256 cellar: :any,                 ventura:       "4be1ca5b65c2d9e04732df0d9a158adaa2b0c84ac56006c810a7d676240be22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "594ffcf0f5f533e5694bdf2c0817083daf490b3681b9c67386d1a85ed2fcefd3"
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