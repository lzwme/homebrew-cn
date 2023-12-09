require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.7.tgz"
  sha256 "f9b0862824d14bdf4fd9477f620bba237c557a13e70a075ca7b454049384bcad"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e35e3fe5638c59a03bb2602e47d13b6a93fae74e8cd231c3b4ab321443bd7705"
    sha256 cellar: :any,                 arm64_ventura:  "e35e3fe5638c59a03bb2602e47d13b6a93fae74e8cd231c3b4ab321443bd7705"
    sha256 cellar: :any,                 arm64_monterey: "e35e3fe5638c59a03bb2602e47d13b6a93fae74e8cd231c3b4ab321443bd7705"
    sha256 cellar: :any,                 sonoma:         "1e2129cf56a260a84c107c72867ef7132b31bf1e57406142135178d0ea51b468"
    sha256 cellar: :any,                 ventura:        "1e2129cf56a260a84c107c72867ef7132b31bf1e57406142135178d0ea51b468"
    sha256 cellar: :any,                 monterey:       "1e2129cf56a260a84c107c72867ef7132b31bf1e57406142135178d0ea51b468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31db2f3c78d48ca71d545b73686febf61b22dfb835790fa61e43ce6c1ac45ff3"
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