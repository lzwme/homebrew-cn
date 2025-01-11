class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.2.tgz"
  sha256 "ff75d1e3325b7ccf054e84d65abe0c14db598eab985121d06e407208bfd303db"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b6148464e5dae545dca0885fd6551ef8e782942de0071eea0a1e0f6449735bf"
    sha256 cellar: :any,                 arm64_sonoma:  "9b6148464e5dae545dca0885fd6551ef8e782942de0071eea0a1e0f6449735bf"
    sha256 cellar: :any,                 arm64_ventura: "9b6148464e5dae545dca0885fd6551ef8e782942de0071eea0a1e0f6449735bf"
    sha256 cellar: :any,                 sonoma:        "d156d59dfb7042baff78040d2d1492af04dabe292299c342516b3bded3899489"
    sha256 cellar: :any,                 ventura:       "d156d59dfb7042baff78040d2d1492af04dabe292299c342516b3bded3899489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb3c23456443ca57da33884693df518e5abb2a27bb18e3d685d475f641d74ba"
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