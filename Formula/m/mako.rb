class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.10.tgz"
  sha256 "5b736572d28be0c572c965cdb273235c8a9a318d2bca1b7da419e758e2b89c13"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "f5f63db6ae78a8a89fcc3482d4e53050cdf6afb0060e05feb75fa4241e6cb9d0"
    sha256                               arm64_ventura:  "71f94a98ffe84f7e7510a9f851ade95294f5441f13f0c900cbfd1d9b1a6f3751"
    sha256                               arm64_monterey: "b1a2ceb2d32a8ecadad33328c4b72d9273c4c667f5ab24a1d49c95171bd66c44"
    sha256                               sonoma:         "fd536f72768e5e7f7277fb6f6797827c0a0db7a69942414c9fee110ca0a1707a"
    sha256                               ventura:        "b6ff34ba9ff710d75879d411fbf74332e3224cddedcffe9b061fea28ca80cbaa"
    sha256                               monterey:       "a77e8d289136e6fc27950a900b00259938beb4f902484afe4c5474acf9550f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05404c968c0016df5d232b28236a68d7a8fb5af0ed8cadb91213c571b3df85a"
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