require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.1.1.tgz"
  sha256 "19d52b36e7dc91f2338da2f4e1165c8d7d1e17b30d03d20cfbfb182dfcc79bc6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "943e1acec268ccd05d903d35a2d56891fc68b6eaf90f7e41d7ff4d63c3dee710"
    sha256 cellar: :any,                 arm64_ventura:  "943e1acec268ccd05d903d35a2d56891fc68b6eaf90f7e41d7ff4d63c3dee710"
    sha256 cellar: :any,                 arm64_monterey: "943e1acec268ccd05d903d35a2d56891fc68b6eaf90f7e41d7ff4d63c3dee710"
    sha256 cellar: :any,                 sonoma:         "076d80b20453eadf017f09ac8bd2b6b9242433ff0f352970e12de1847dabca87"
    sha256 cellar: :any,                 ventura:        "076d80b20453eadf017f09ac8bd2b6b9242433ff0f352970e12de1847dabca87"
    sha256 cellar: :any,                 monterey:       "076d80b20453eadf017f09ac8bd2b6b9242433ff0f352970e12de1847dabca87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee345f92e9aeda5ffe53244f78fa691ed22f4b7d6023a06ef4f5ac720d71170"
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