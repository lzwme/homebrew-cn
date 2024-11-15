class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.6.tgz"
  sha256 "7274a7af2fcfd251f7bb5dfd9605ca831418153112dd9976d2f8d7a75799add1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e5c4784d9dbbbeb1283889b2cebb50ea8c4f31d6817dfaf5ccb8792d65286d2"
    sha256 cellar: :any,                 arm64_sonoma:  "8e5c4784d9dbbbeb1283889b2cebb50ea8c4f31d6817dfaf5ccb8792d65286d2"
    sha256 cellar: :any,                 arm64_ventura: "8e5c4784d9dbbbeb1283889b2cebb50ea8c4f31d6817dfaf5ccb8792d65286d2"
    sha256 cellar: :any,                 sonoma:        "070aeaa7734f3a8320118c70233ab6d00e3f02a6adf41a0cbe64ffdf992f4d66"
    sha256 cellar: :any,                 ventura:       "070aeaa7734f3a8320118c70233ab6d00e3f02a6adf41a0cbe64ffdf992f4d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf84ae8b3577e729ac7388b9abb3e2544cc0a1fd0b0a1a7e24bc7311c808cb3"
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