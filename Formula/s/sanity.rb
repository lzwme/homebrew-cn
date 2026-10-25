class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.23.0.tgz"
  sha256 "69080479614b26a2a3e2118d7eb1972fa48610ffd4b962b35f295b2803abe593"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1966e487d8a8868d3231f57a5e6b3e5f104fbe49a8759d3c19aa2accb019ff0b"
    sha256 cellar: :any, arm64_tahoe:       "1966e487d8a8868d3231f57a5e6b3e5f104fbe49a8759d3c19aa2accb019ff0b"
    sha256 cellar: :any, arm64_sequoia:     "1966e487d8a8868d3231f57a5e6b3e5f104fbe49a8759d3c19aa2accb019ff0b"
    sha256 cellar: :any, arm64_linux:       "d83aef73c599550f8d6783ae0bcca6fb8c00cad326f7a85bc8182a7de925b73a"
    sha256 cellar: :any, x86_64_linux:      "474483d096d7d62aa864a50bb44e47b3c46b2d9b1655aec798ee849b101457d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end