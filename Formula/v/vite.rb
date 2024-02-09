require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.1.0.tgz"
  sha256 "497bd2f4a8b11922dff4b57b2b4ce01cb63f5015a5b2f8f18c9574376f12d28e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c16b17830768a380bb5026937740bb53d652963bf3d3c1afb9957bcaf140e8e3"
    sha256 cellar: :any,                 arm64_ventura:  "c16b17830768a380bb5026937740bb53d652963bf3d3c1afb9957bcaf140e8e3"
    sha256 cellar: :any,                 arm64_monterey: "c16b17830768a380bb5026937740bb53d652963bf3d3c1afb9957bcaf140e8e3"
    sha256 cellar: :any,                 sonoma:         "a44fd1137e1bb5f1bba3d121a470ed09a71bbefa7ae2640ac669d9604852d411"
    sha256 cellar: :any,                 ventura:        "a44fd1137e1bb5f1bba3d121a470ed09a71bbefa7ae2640ac669d9604852d411"
    sha256 cellar: :any,                 monterey:       "a44fd1137e1bb5f1bba3d121a470ed09a71bbefa7ae2640ac669d9604852d411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffe23a34501220529d0b60d3567918484195d510539d40e68d36fc0c558f9ea7"
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