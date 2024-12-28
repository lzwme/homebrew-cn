class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.11.0.tgz"
  sha256 "6a56e4cadc91aedfa1873c9f75e59d8acc1d39e39e118237b4f00079b93382ab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36159887567337d93ed8d3854f6a21d7b0867705e6ba8d2a1a8bcbf73129d712"
    sha256 cellar: :any,                 arm64_sonoma:  "36159887567337d93ed8d3854f6a21d7b0867705e6ba8d2a1a8bcbf73129d712"
    sha256 cellar: :any,                 arm64_ventura: "36159887567337d93ed8d3854f6a21d7b0867705e6ba8d2a1a8bcbf73129d712"
    sha256 cellar: :any,                 sonoma:        "086dfaaa0f19cf199e014071d13b6de33c359da9ac15bfa52951e070557cea8c"
    sha256 cellar: :any,                 ventura:       "086dfaaa0f19cf199e014071d13b6de33c359da9ac15bfa52951e070557cea8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb83bc45e0ee8a168bff17951bfe74b2ddcc60485de3e6c89e55853796adba53"
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