require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.9.tgz"
  sha256 "914a1c35b622302f7ee6e88f8336d9d62f64986ea614907d3e593ecffb7059d5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "789129112f70a8b5ce1949f8d6c3738d80fb6a53648204264cb71f6775f39ca5"
    sha256 cellar: :any, arm64_ventura:  "789129112f70a8b5ce1949f8d6c3738d80fb6a53648204264cb71f6775f39ca5"
    sha256 cellar: :any, arm64_monterey: "789129112f70a8b5ce1949f8d6c3738d80fb6a53648204264cb71f6775f39ca5"
    sha256 cellar: :any, sonoma:         "688df8a9ccc59e555ff4862b83dcd21c111e029b1fc18f789d5d5836fcb6abcf"
    sha256 cellar: :any, ventura:        "688df8a9ccc59e555ff4862b83dcd21c111e029b1fc18f789d5d5836fcb6abcf"
    sha256 cellar: :any, monterey:       "688df8a9ccc59e555ff4862b83dcd21c111e029b1fc18f789d5d5836fcb6abcf"
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