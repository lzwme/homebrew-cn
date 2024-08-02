require "language/node"

class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.9.tgz"
  sha256 "68e4f5e8dcf82ded63f6b193d1f602f7c7ec6f004a310d5f1c8588e267099b2d"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "dc1939ed03b4b9b439021c0723bf20c8d2fb312a0a75ce0885685e943902895f"
    sha256                               arm64_ventura:  "7e46f6175eab4e570e1e078ccc8097ea00bbd31938f5f10da96b38e05ff7c157"
    sha256                               arm64_monterey: "63b2702699f127e502af841b279036b4579e255cb2579fc89417138c40edb75b"
    sha256                               sonoma:         "cdfa008731d773036e54aec1b76b6ab74471cced935fe7a360b2514dc3cbb0c4"
    sha256                               ventura:        "a5339b9f552cbe68838e9981dc28434a9a11c19a104fe1050f2458eabd50d8b7"
    sha256                               monterey:       "ea285d2ef7540675fec0261aad211b48fef750c9328748105b44999f631a546b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e428961bc7907a8373eabee9a857f9df0044efe90060a7aadf5f5f4ac14d709a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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