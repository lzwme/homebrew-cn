class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.0.tgz"
  sha256 "1f3523a3779cccf681a744ff848d28f4d4801cd410636831401d12435da2f9c8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07bc16f9813d0d81dfc3906e945c486c2f55de2d943e37af77cf94ae3a903ff9"
    sha256 cellar: :any,                 arm64_sonoma:  "07bc16f9813d0d81dfc3906e945c486c2f55de2d943e37af77cf94ae3a903ff9"
    sha256 cellar: :any,                 arm64_ventura: "07bc16f9813d0d81dfc3906e945c486c2f55de2d943e37af77cf94ae3a903ff9"
    sha256 cellar: :any,                 sonoma:        "faf16d364c91ae3ee13d641aedcbfc2e282402990a43f2a2761715f361c7f490"
    sha256 cellar: :any,                 ventura:       "faf16d364c91ae3ee13d641aedcbfc2e282402990a43f2a2761715f361c7f490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17781993392ea7cf3cfde3516a9d211da27d79f697e64512ddf5d7ff1183d5f"
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