class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.9.tgz"
  sha256 "68e4f5e8dcf82ded63f6b193d1f602f7c7ec6f004a310d5f1c8588e267099b2d"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "d8a8a370bd43963430bd081192e996c63585a9c5e0f8948dd731bd72e982f878"
    sha256                               arm64_ventura:  "6974949c4ec3b54dd8064005a2251e49761652771e3aca684074b6f8d4bf40f4"
    sha256                               arm64_monterey: "907d4d7b1256d3e1fbc1719df82bb7957fa061749b7ae63868dce1b57f80154e"
    sha256                               sonoma:         "3ffd4d42c8a69863d5fc6318ed1b94e4b653c77caf3fd59d756394006d4d357f"
    sha256                               ventura:        "e8f0e438531d5f87c6e11f061f7dec341440e6402dab85470f8bc4b56cc8607e"
    sha256                               monterey:       "6a1b8f6face05229edbe5291262276f1815493dbc0dfb2013e9ac319cb30b94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54229eab00b16827f101fc681cfe9e95f1176f71a50adcd364a1871deafbc063"
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