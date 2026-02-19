class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.11.1.tgz"
  sha256 "7ee235ea59ddec80ca4e9883f60a11e6315cc78b78ad7ca400ab919ac30ece51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "624ad507d564cb2fcfb1687ff8107e4568a25070175d33247044bb77159256fa"
    sha256 cellar: :any,                 arm64_sequoia: "8b00b6b92cf83fa60c1d8de70b60f798cf860ae1650a40d4bb929d8f65eaeca7"
    sha256 cellar: :any,                 arm64_sonoma:  "8b00b6b92cf83fa60c1d8de70b60f798cf860ae1650a40d4bb929d8f65eaeca7"
    sha256 cellar: :any,                 sonoma:        "4adf928d837e8ef846146d49e25c28a14c20d2b894a88c151ad7c8948862a599"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aa5183b075918b3cccbbea9c89d3c346d3c1313c75dabee37d834030bf432cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910eff7738466db1f325101d325b7ada09f38c6675dda475504af3826bce57fa"
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