class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.7.tgz"
  sha256 "58b10e13692dc9fabb3caf358cdf9ea98c2e91a7e46714b2eb1d293b6a313b9b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c09ac83fbc3c4812e4407b5f094a9442c398e7bdcede4e4244db070f11b4cb5e"
    sha256 cellar: :any,                 arm64_sonoma:  "c09ac83fbc3c4812e4407b5f094a9442c398e7bdcede4e4244db070f11b4cb5e"
    sha256 cellar: :any,                 arm64_ventura: "c09ac83fbc3c4812e4407b5f094a9442c398e7bdcede4e4244db070f11b4cb5e"
    sha256 cellar: :any,                 sonoma:        "894cdcb2f5cc39ec5f10299bfb8fb4a8f26c2c207c5404bad793b6e502e48d5b"
    sha256 cellar: :any,                 ventura:       "894cdcb2f5cc39ec5f10299bfb8fb4a8f26c2c207c5404bad793b6e502e48d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f8bd1003e132242d4a8db644b54e33455fbe32d1a055671de67c87523bf6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbe8bce2b0eff9ab41951874f639d14f80e62aa033a87357ae76dfa9938833a7"
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