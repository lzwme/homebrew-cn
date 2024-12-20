class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.10.0.tgz"
  sha256 "3f5e52d71a6681a8e1a4def1ef53cf4c496e490ce2fc9ed8e4e5da6a1c6b8928"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f6a7b95ac0606e9edddfd9943157e65eda9065b670bbabaa53539f85d0734fa"
    sha256 cellar: :any,                 arm64_sonoma:  "7f6a7b95ac0606e9edddfd9943157e65eda9065b670bbabaa53539f85d0734fa"
    sha256 cellar: :any,                 arm64_ventura: "7f6a7b95ac0606e9edddfd9943157e65eda9065b670bbabaa53539f85d0734fa"
    sha256 cellar: :any,                 sonoma:        "b7bf0a081f34e12c7fafe6aea4dc64a24f6f066513368ed43fb08d231f024d8f"
    sha256 cellar: :any,                 ventura:       "b7bf0a081f34e12c7fafe6aea4dc64a24f6f066513368ed43fb08d231f024d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5d56558fc11da35da544a084f1ec0b16e9690a8e16004648ca62bf7d21598c0"
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