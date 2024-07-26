require "language/node"

class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.7.8.tgz"
  sha256 "b0219ded0a0595688ddaebcf0415226d913d635988a6151d81b4678e69cbacc2"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "9694d708be0ddb5b84c287bbd4c7453571659080da33aaa11bf7590b2c80c1cc"
    sha256                               arm64_ventura:  "82efc6f0297bc46ff92ab8d6f622fcb44e34d28effe5e03e0557447e8ad42cb1"
    sha256                               arm64_monterey: "b6e51dc870283e0b1b5d93fa3d19d4e23cd59ae941e106d961a4ecc261722fe9"
    sha256                               sonoma:         "1eeef55203dbeb5929d86d0a32a7d150cff98acb54d55f94e20b7af963ba5eb6"
    sha256                               ventura:        "0792b15124e60e7a01f089bf42e5fd8c583dc899adbe2a508a2e8430bbac3a7c"
    sha256                               monterey:       "0023ce3bd717511ab236499b86022d9565680b89cc691d6c81fee654451e3b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b7a6e38c9bc5fd39185e94f3e318bc27ff92ab219d89f918d1b88f46f6e68e"
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