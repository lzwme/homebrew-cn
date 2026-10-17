class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.17.1.tgz"
  sha256 "5b12ceb46e05bff6cb6a1f7363cc027a2b0a99dcde8ff365aae578824a8764a3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e22e3622c0ffb5afded8397d166e1457b488653b5b75b08c63ea4e68c229b4e"
    sha256 cellar: :any, arm64_tahoe:       "0e22e3622c0ffb5afded8397d166e1457b488653b5b75b08c63ea4e68c229b4e"
    sha256 cellar: :any, arm64_sequoia:     "0e22e3622c0ffb5afded8397d166e1457b488653b5b75b08c63ea4e68c229b4e"
    sha256 cellar: :any, arm64_linux:       "8cd82bfe07b20feeacf41145c52fd206a03f9dc40443cd62b428977b069a982f"
    sha256 cellar: :any, x86_64_linux:      "1c97722cb8a96290586be92bbe9d63a1369ceeaede641993ab1abc7afb1ceca1"
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