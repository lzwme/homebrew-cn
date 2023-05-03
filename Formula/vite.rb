require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.4.tgz"
  sha256 "b6cc6ec2261a7282e8b3c409c05af2ab721b399debd732ef0a83de9723b7744b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61bf20e15ed2a4207cd2f88dee8ba8041aba6d41fa9365dd96849b3c5491a174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61bf20e15ed2a4207cd2f88dee8ba8041aba6d41fa9365dd96849b3c5491a174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61bf20e15ed2a4207cd2f88dee8ba8041aba6d41fa9365dd96849b3c5491a174"
    sha256 cellar: :any_skip_relocation, ventura:        "baf212a442d36a52c25ab3f70be091a4cc243e0bf7ce5cb4daa169104fb58b18"
    sha256 cellar: :any_skip_relocation, monterey:       "baf212a442d36a52c25ab3f70be091a4cc243e0bf7ce5cb4daa169104fb58b18"
    sha256 cellar: :any_skip_relocation, big_sur:        "baf212a442d36a52c25ab3f70be091a4cc243e0bf7ce5cb4daa169104fb58b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef8cb48d9fd372779fad02856b0e3f69782949613c64b7edb5dfca88bb310026"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end