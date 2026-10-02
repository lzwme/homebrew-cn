class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.6.0.tgz"
  sha256 "591833d9e8fb354af2c26706126be6e7d7cbb6c88d98be669a1c923d7ecb8d98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6aa6324a88bbf83e065fcf315768d68172721bdbbf1cc20bcdaa9963db910838"
    sha256 cellar: :any, arm64_tahoe:       "6aa6324a88bbf83e065fcf315768d68172721bdbbf1cc20bcdaa9963db910838"
    sha256 cellar: :any, arm64_sequoia:     "6aa6324a88bbf83e065fcf315768d68172721bdbbf1cc20bcdaa9963db910838"
    sha256 cellar: :any, arm64_linux:       "77ff15b815d67ef460600bbbecf76b29a8884006074bd845c930505dc32247e2"
    sha256 cellar: :any, x86_64_linux:      "10dd798e78d2772127738db4e7477d63eb13eb12cba9e3d4a3186a30c2a26c9e"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end