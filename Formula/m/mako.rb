class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.9.8.tgz"
  sha256 "8f0244570a53a0b09cfa3db4baa48d16093f5af6c302a514d835b6be69a2db0c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50a1eb2d39c310810a3feb36a869b67fa780e7a3eebbcd4db7c116d844f0f190"
    sha256 cellar: :any,                 arm64_sonoma:  "50a1eb2d39c310810a3feb36a869b67fa780e7a3eebbcd4db7c116d844f0f190"
    sha256 cellar: :any,                 arm64_ventura: "50a1eb2d39c310810a3feb36a869b67fa780e7a3eebbcd4db7c116d844f0f190"
    sha256 cellar: :any,                 sonoma:        "444917e3f4d0388829d92d6f557010fc42b4360b2fb56c047f8b6c7dee947624"
    sha256 cellar: :any,                 ventura:       "444917e3f4d0388829d92d6f557010fc42b4360b2fb56c047f8b6c7dee947624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aef8889738b658a7de2844b9feb4a72e299a34c5ba0eaa21e86f987d97337f0"
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