require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.7.tgz"
  sha256 "44218b8ebb9f986d28b44ef86c7b5bee1f418248eb724aec691f9d66359592ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "196d42f28a9b04c25b38931c4d5181b696afc54699c4874e93d3166d3b66f362"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196d42f28a9b04c25b38931c4d5181b696afc54699c4874e93d3166d3b66f362"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "196d42f28a9b04c25b38931c4d5181b696afc54699c4874e93d3166d3b66f362"
    sha256 cellar: :any_skip_relocation, ventura:        "cc21b4fde57fabd3f1067b8896973f0919c6c3d60b75f48883ed58875fa9d0a2"
    sha256 cellar: :any_skip_relocation, monterey:       "cc21b4fde57fabd3f1067b8896973f0919c6c3d60b75f48883ed58875fa9d0a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc21b4fde57fabd3f1067b8896973f0919c6c3d60b75f48883ed58875fa9d0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7e4106bbe47d8d61b943c2bb46d3550dc268a50e8aa103412e26c6a789e93c"
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