class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.3.tgz"
  sha256 "c7434945803556184f0d09fd919bf0d2baac01fc8a823caf24b363b0b7f66ceb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29267577a2def1d8a1cd4b597c26fc3b54ba1e3e2b71512bdf10ee43725df8d2"
    sha256 cellar: :any,                 arm64_sonoma:  "29267577a2def1d8a1cd4b597c26fc3b54ba1e3e2b71512bdf10ee43725df8d2"
    sha256 cellar: :any,                 arm64_ventura: "29267577a2def1d8a1cd4b597c26fc3b54ba1e3e2b71512bdf10ee43725df8d2"
    sha256 cellar: :any,                 sonoma:        "0b608d985cca07b5f605e3a429319e8591da057c08b2d739bcacf99ee83f0097"
    sha256 cellar: :any,                 ventura:       "0b608d985cca07b5f605e3a429319e8591da057c08b2d739bcacf99ee83f0097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c652a43d25ef6b6a02f50a322306adac914d5f102ac45ea1521a44a28832ec67"
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