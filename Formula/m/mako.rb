class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.4.tgz"
  sha256 "b0f5901156420d5aa69bbad5686c479f85455d193f3323cc19482c70c71e7099"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "451ec1163489d50ae7fe29b8474dfb76b83f98af082131382d229a4a326a0879"
    sha256 cellar: :any,                 arm64_sonoma:  "451ec1163489d50ae7fe29b8474dfb76b83f98af082131382d229a4a326a0879"
    sha256 cellar: :any,                 arm64_ventura: "451ec1163489d50ae7fe29b8474dfb76b83f98af082131382d229a4a326a0879"
    sha256 cellar: :any,                 sonoma:        "ea37c061aff5616e49cd4c0bb99aa8c683a217b64c056156bc106d8b990b63d8"
    sha256 cellar: :any,                 ventura:       "ea37c061aff5616e49cd4c0bb99aa8c683a217b64c056156bc106d8b990b63d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b13938ade3cdf5eea36359d37ea1f7b8b1a2c1a27fca2cd564e85dd817536f"
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