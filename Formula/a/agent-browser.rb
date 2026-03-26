class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.22.3.tgz"
  sha256 "8731d0fb2aa85697beeedb310e706b4b7b66264d1a550f34c824064f9225e969"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e9c9b669757b86b79a82228355d7f0c763a66c1652a5d6e8de50c7ac8be7a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34e9c9b669757b86b79a82228355d7f0c763a66c1652a5d6e8de50c7ac8be7a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e9c9b669757b86b79a82228355d7f0c763a66c1652a5d6e8de50c7ac8be7a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4e00ab3603422af7b04d2bfea22376179950410d944c9b746ec776b11f9dd2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e62b182f94840a66421f145614ffcb7773bc06ab20086e9a5382b6e60d166f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d038bfce85e14e49fac913aec2d3a0e1d5d535140b1d94a3a1bad3cc4b29cb93"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end