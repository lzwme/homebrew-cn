class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.6.tgz"
  sha256 "476a0b4270c82d661b2b03bf6ff68475054a62e82bb266e5bb1468444374239c"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "4062cec5c19e4cc2536092778be46c99acc3f5d0da640f5116fd29110d42881e"
    sha256                               arm64_ventura:  "3c1e90ec953fa811c0a3f19813bcb4258aae757adafca82435400286d9a4e268"
    sha256                               arm64_monterey: "f46d2fa7579dbe4947bc24d6089114cd595d73585af16af96f8fbf182400ac1f"
    sha256                               sonoma:         "9bb41647f659191344657d87228852aa51ddd0897c542b0649c10c37f798a3a9"
    sha256                               ventura:        "e314fea80f83885b1702c20edc85332b95746aa1e800b05bada2edd493e338f3"
    sha256                               monterey:       "05cd44a8bc477ce619c77aa8eb95aa8e3d78a77190148ce20e72f5c1b56aae4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ed6ae5578ca6216e2f8168cff1b7a173cbc6c87c8519fd5a1dd165f64ed646"
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