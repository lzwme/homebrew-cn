class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.7.tgz"
  sha256 "71d7fc962dfcec1b61ae4caec71fe1b64477bed395817140ddbfeb6cb3cb8e93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ad109d60c0ab198b3bb278cc4120da20504d7b936f364a879f617bfae1e2c6d"
    sha256 cellar: :any,                 arm64_sonoma:  "0ad109d60c0ab198b3bb278cc4120da20504d7b936f364a879f617bfae1e2c6d"
    sha256 cellar: :any,                 arm64_ventura: "0ad109d60c0ab198b3bb278cc4120da20504d7b936f364a879f617bfae1e2c6d"
    sha256 cellar: :any,                 sonoma:        "347c3ebb76e156948fe57b2fede5b06b83841ac6f7ce8152ccf2ef96a0fced6a"
    sha256 cellar: :any,                 ventura:       "347c3ebb76e156948fe57b2fede5b06b83841ac6f7ce8152ccf2ef96a0fced6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50eae00267fbf3fafe36313ebac5433792b91438f84df2f01eec2b1b30c18d4"
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