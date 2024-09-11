class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.11.tgz"
  sha256 "4c69b9ed105efa29d2fe1f2401598f158016b146b180a41fb51651e0a87428a1"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "4d3581930d9043b8de0c9ed49cc0e8cebed1f48c509b4c70182d52317da8b388"
    sha256                               arm64_ventura:  "6a919c837e507e2ab3b1981c94001d3c483d3a21a1a22a95fe9377136fec1310"
    sha256                               arm64_monterey: "7adf717c22ab819603f3bc74dc834a9360c84a3455e4a79e84b41da49a9c1645"
    sha256                               sonoma:         "afcd1a09f225c2b7def9bd2ede90bc3805a7a5b178b738ec316286ea1e693d99"
    sha256                               ventura:        "6c15e6b0d8d907f920836c7a40fc3e1b0fbe19d138327033e7ae3af63d0e73f7"
    sha256                               monterey:       "736fd1d0513d20b91f66605f4c70d72867d3da3ce6a89ee1ea5a7b9121a0a513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e300f0ee0367cf390220b172494471a75ae5f49dd1a37daf643f3a8add607845"
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