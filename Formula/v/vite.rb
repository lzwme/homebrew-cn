require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.11.tgz"
  sha256 "741852f3cbb66b6676ca0cd0870e15a464d83d3dda204b69a77fe6c2975ad2e4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46f7de3e3c1f7bad3b2199bb059a959a0f414ef2bcd2208fafcba1749260bca1"
    sha256 cellar: :any,                 arm64_ventura:  "46f7de3e3c1f7bad3b2199bb059a959a0f414ef2bcd2208fafcba1749260bca1"
    sha256 cellar: :any,                 arm64_monterey: "46f7de3e3c1f7bad3b2199bb059a959a0f414ef2bcd2208fafcba1749260bca1"
    sha256 cellar: :any,                 sonoma:         "13e67145f39434f1b74ebf2b1a643a09270b13ba1050c32f16a069d539bd458c"
    sha256 cellar: :any,                 ventura:        "13e67145f39434f1b74ebf2b1a643a09270b13ba1050c32f16a069d539bd458c"
    sha256 cellar: :any,                 monterey:       "13e67145f39434f1b74ebf2b1a643a09270b13ba1050c32f16a069d539bd458c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ccc4ee7a2dfb6254d7f8c044ec617b0fcc5b6a7c2f102a22b59be0bec42a158"
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