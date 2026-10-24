class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.22.1.tgz"
  sha256 "92932409707a74dbd2a47c4526d2f14a4e1b1bd4540f3da51e63ac2a620f8868"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "81489d09d53a7b2813cfed721424623624a2a6e283fa9a27e2b22ad8f1b92d30"
    sha256 cellar: :any, arm64_tahoe:       "81489d09d53a7b2813cfed721424623624a2a6e283fa9a27e2b22ad8f1b92d30"
    sha256 cellar: :any, arm64_sequoia:     "81489d09d53a7b2813cfed721424623624a2a6e283fa9a27e2b22ad8f1b92d30"
    sha256 cellar: :any, arm64_linux:       "44f564d8b3a40e0fca1727a597409dd0d5f798c7843cee73e230a2f226476a0b"
    sha256 cellar: :any, x86_64_linux:      "1030fec98153a5b4ab2d9dab5bed2afacaba7578ba694d037e11e97f95892e51"
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