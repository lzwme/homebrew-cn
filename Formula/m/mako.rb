class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.7.tgz"
  sha256 "e75c955309be49db608203e72fdaade737f40d312308b78034bb4f0dd144e8ee"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "28149b45903444ce1a30a613f1efedae31ac1dc15c585106f73ebd5cd182c9ae"
    sha256                               arm64_ventura:  "49c0da41e096eba8e9d9a1b5091855b6d1a091ca53837f2cc4d5cd78caedf979"
    sha256                               arm64_monterey: "174686beaaed7a4451e04b26fb2f29dbd00ff52068b2f8fe1093de3262fa9f4b"
    sha256                               sonoma:         "2ae9fea598f69e2f6ef36867c225603e05f4fe7f74f484d05cf8edc73dbb7729"
    sha256                               ventura:        "d965903692a3d72683dbf894ba1b792cd6799d4c38f4b46dfbec8eec6287f80d"
    sha256                               monterey:       "58ef827fb659afada69386d883a52378ec80eb6d75b4bae150231a2340a383d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e56c80b023c363455eff7d350ef1587942af8e339bb0f59ddc670f8acacc0c"
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