class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.9.0.tgz"
  sha256 "9995b034e5d166d020224537f22902f097d1af547bc838810ae749fc227b3836"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6b3a63c57534791574a9fdd9182163c3183b2ae7985ca75d5e432400a83ced43"
    sha256 cellar: :any, arm64_sequoia: "6b3a63c57534791574a9fdd9182163c3183b2ae7985ca75d5e432400a83ced43"
    sha256 cellar: :any, arm64_sonoma:  "6b3a63c57534791574a9fdd9182163c3183b2ae7985ca75d5e432400a83ced43"
    sha256 cellar: :any, sonoma:        "53803639f94c63faed1505fd8d54e0cf5e3e4a0fb1919e04b50a49bb5214d6f5"
    sha256 cellar: :any, arm64_linux:   "0f419be035e8c950918be72da8a45f66480c55e8587ddd7adb23954b28259ea8"
    sha256 cellar: :any, x86_64_linux:  "2890bf4e4936d9b765544d8ca2d8cc65f0b53b3b10716926dd4107ea484ec0a7"
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