require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.5.tgz"
  sha256 "db427c2ca7e5cd9944780f82644ded47ce1f575cb9703e9ae9221a038efb35c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5f9bbe6497a3d4867bf8db04ed4a392cb876f86c42edb06e8a28df44a34b840"
    sha256 cellar: :any,                 arm64_ventura:  "d5f9bbe6497a3d4867bf8db04ed4a392cb876f86c42edb06e8a28df44a34b840"
    sha256 cellar: :any,                 arm64_monterey: "d5f9bbe6497a3d4867bf8db04ed4a392cb876f86c42edb06e8a28df44a34b840"
    sha256 cellar: :any,                 sonoma:         "bc3752cc75e9e39356b1a67bce37fdfad9326716775c1ec0b7a373621e95cbfe"
    sha256 cellar: :any,                 ventura:        "bc3752cc75e9e39356b1a67bce37fdfad9326716775c1ec0b7a373621e95cbfe"
    sha256 cellar: :any,                 monterey:       "bc3752cc75e9e39356b1a67bce37fdfad9326716775c1ec0b7a373621e95cbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7372da6a6b4fb5c4073c02955f07fa416df1694a840238e1cb42c4ddff16d0"
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