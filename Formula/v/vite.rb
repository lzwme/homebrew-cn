require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.6.tgz"
  sha256 "6cdc2e4c5d4b34face641e3675fb9042c71d963310fbc05b842b567a04c8234c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75d5c093f71472d585f1a8ee1160be7681961e3b7baab977478055d07c315ed1"
    sha256 cellar: :any,                 arm64_ventura:  "75d5c093f71472d585f1a8ee1160be7681961e3b7baab977478055d07c315ed1"
    sha256 cellar: :any,                 arm64_monterey: "75d5c093f71472d585f1a8ee1160be7681961e3b7baab977478055d07c315ed1"
    sha256 cellar: :any,                 sonoma:         "c11143670864464f59428a4801edc73bdd5209017a5f336dbe80381420bedd8f"
    sha256 cellar: :any,                 ventura:        "c11143670864464f59428a4801edc73bdd5209017a5f336dbe80381420bedd8f"
    sha256 cellar: :any,                 monterey:       "c11143670864464f59428a4801edc73bdd5209017a5f336dbe80381420bedd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "699b9c09a5c0ccd0b8217be6adc8875788aad1266ed2b1da9ac7d0a12781a0fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/vite/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end