class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.14.tgz"
  sha256 "102256fdaffff92910a1beb9c02f6779ae93f6da711670e47138ff57bd252893"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "72bcf61f7d52aa03e3ee3dafc37f2455be1832c75cee06402ddba457238f9f0a"
    sha256 cellar: :any,                 arm64_sequoia: "03e5ddd3e33e06a8afe46be6d39f573001b839d934731b5fa99cd9f788e68cbb"
    sha256 cellar: :any,                 arm64_sonoma:  "03e5ddd3e33e06a8afe46be6d39f573001b839d934731b5fa99cd9f788e68cbb"
    sha256 cellar: :any,                 sonoma:        "005fe26ea8598c41805997614f13588399320501bfa1f2340814b7671ada5f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191d7501c925b9f744d7fbf22cbf7c86349fbf7fcd2e105cc7855b96b20a83b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf49f1a492d60f0ab6841d3acadee45b0abd12ce71270a66680a96d139a4224e"
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