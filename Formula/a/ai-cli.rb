class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.6.1.tgz"
  sha256 "fb04bd641b7afff1a9a89e8857cc568b8962344d72b6289e10f64e1dd5db0ef2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "750439fc3c49e6fd37aed3cf5aba9e2e30453a6e1f7ad8ebc596ccafb440201a"
    sha256 cellar: :any, arm64_tahoe:       "750439fc3c49e6fd37aed3cf5aba9e2e30453a6e1f7ad8ebc596ccafb440201a"
    sha256 cellar: :any, arm64_sequoia:     "750439fc3c49e6fd37aed3cf5aba9e2e30453a6e1f7ad8ebc596ccafb440201a"
    sha256 cellar: :any, arm64_linux:       "58160cfbaea60531b4b5cb8fa4788917bbd2e549a751d60cff2e7012e7b91713"
    sha256 cellar: :any, x86_64_linux:      "f50a4b413a340e5fc5a34e0c7bde570773a7b6c380ecfbc3cf5c847bbedf4703"
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