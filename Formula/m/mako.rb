class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.1.tgz"
  sha256 "2fa0966519af4747366fcbc6000aebc61cea310a31fc5a6295860c1ae0c156cb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6a97c83e8dc413f976ea589a3225a0c775d16cd47188c62861fb2913ada712c"
    sha256 cellar: :any,                 arm64_sonoma:  "c6a97c83e8dc413f976ea589a3225a0c775d16cd47188c62861fb2913ada712c"
    sha256 cellar: :any,                 arm64_ventura: "c6a97c83e8dc413f976ea589a3225a0c775d16cd47188c62861fb2913ada712c"
    sha256 cellar: :any,                 sonoma:        "a26acec4976cade953924af9776d67a853e51c2c2a27a8c4534c40f6128040ed"
    sha256 cellar: :any,                 ventura:       "a26acec4976cade953924af9776d67a853e51c2c2a27a8c4534c40f6128040ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd0cc4a84342349aafcc333a925a097076e91a9ed91c04c76d1fd9bef6e0b359"
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