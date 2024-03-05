require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.1.5.tgz"
  sha256 "333846a6d7336cc75c96a46ec386d562232da15864ad37fc10acb954dc7db5ab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e7b9576a3f6b627733eb30cba1da3e8b86da2fc034ddc65a6935a0dead0bf4be"
    sha256 cellar: :any,                 arm64_ventura:  "e7b9576a3f6b627733eb30cba1da3e8b86da2fc034ddc65a6935a0dead0bf4be"
    sha256 cellar: :any,                 arm64_monterey: "e7b9576a3f6b627733eb30cba1da3e8b86da2fc034ddc65a6935a0dead0bf4be"
    sha256 cellar: :any,                 sonoma:         "d8b4684a17e49ee1aa46002794772109624ed6628dd78bcb52f48d9aa000e819"
    sha256 cellar: :any,                 ventura:        "d8b4684a17e49ee1aa46002794772109624ed6628dd78bcb52f48d9aa000e819"
    sha256 cellar: :any,                 monterey:       "d8b4684a17e49ee1aa46002794772109624ed6628dd78bcb52f48d9aa000e819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c348f5eef6e44e43bf81feb9138634f2bd50234a511b3f9ee1e16280726e667"
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