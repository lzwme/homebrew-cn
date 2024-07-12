require "language/node"

class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.5.tgz"
  sha256 "47bdb0c257c34e36ff880ba4902ca67640b66b8d8e1183b21c2b8cf91c9394bb"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "676f4691b3cfa1cdb10d8d4d86a2477036b2bc00864459638d6d58d1e3366a8f"
    sha256                               arm64_ventura:  "172e4071c585ed8a173df7ad22eb04c6b3053ee353e8d6cdd67db590baf2fc6a"
    sha256                               arm64_monterey: "6ef857296ffa8a13f5ab9cc0f2ee2b1750fe449a4dcb7a4a67fccea27771a03a"
    sha256                               sonoma:         "f35f298e412de883fd3d86e649e571909df130f1885741ef237b914f632c8f15"
    sha256                               ventura:        "629873f80067e92981d70328644a7940aa7f4a34cac0adb096967a8d0c27d911"
    sha256                               monterey:       "7752b71b26ce5f1e2ab1197e909bb9ee202a03b45754cbf8d2d3ef337bb0bef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7424f800bad1d71aab90fc6e5e405182b3f8cd76619fe29c4a37c810e6b9117d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end