class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.19.0.tgz"
  sha256 "10b24e1b16f0b31361d5df75a5bd9243936edab6d5212554e4a8b6cd281a3587"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "47201ef366d3664cd3f286e77d8e449a586945cdfd301b3b849811b9ff9cdd16"
    sha256 cellar: :any, arm64_tahoe:       "47201ef366d3664cd3f286e77d8e449a586945cdfd301b3b849811b9ff9cdd16"
    sha256 cellar: :any, arm64_sequoia:     "47201ef366d3664cd3f286e77d8e449a586945cdfd301b3b849811b9ff9cdd16"
    sha256 cellar: :any, arm64_linux:       "9f6c2a9ca93bf4474dc860fa0fc3137a94ee83da03d855f8d4d7fb9a82fee321"
    sha256 cellar: :any, x86_64_linux:      "eae9e514deaae49ec10a634425f6e10b27472b4de7d96e77ee5a6011efcdeb82"
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