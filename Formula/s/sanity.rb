class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.24.0.tgz"
  sha256 "be8ff387a086880d4372384f1e6141903034031caccf7b3c3077ba2b0b69f4c8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5d2e24c248e70a5c0bb932269a7959e0ba8811a790d686ad7b9cf2ec972d1fcf"
    sha256 cellar: :any, arm64_tahoe:       "5d2e24c248e70a5c0bb932269a7959e0ba8811a790d686ad7b9cf2ec972d1fcf"
    sha256 cellar: :any, arm64_sequoia:     "5d2e24c248e70a5c0bb932269a7959e0ba8811a790d686ad7b9cf2ec972d1fcf"
    sha256 cellar: :any, arm64_linux:       "4bfce926e62388158322945343ec48fa31abe0fedf498ddcb30649068344965b"
    sha256 cellar: :any, x86_64_linux:      "6d25128b0078b9253b9066c8386b6180bff984ac2546c20245b07061299fc7af"
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