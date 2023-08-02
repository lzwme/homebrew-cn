require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.8.tgz"
  sha256 "93975960dcd6e1d5064bb2187a4f0e0a9099ba86186f6249d6696ac40f3cae83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb6dc02d4988c18aa08410d03a803e3cd02791d23be25c23224ba2aea8394d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb6dc02d4988c18aa08410d03a803e3cd02791d23be25c23224ba2aea8394d02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb6dc02d4988c18aa08410d03a803e3cd02791d23be25c23224ba2aea8394d02"
    sha256 cellar: :any_skip_relocation, ventura:        "00a10a3c70fa0642ef499fc079d29a139fb3aee99599a08381eee681b3f8aa5f"
    sha256 cellar: :any_skip_relocation, monterey:       "00a10a3c70fa0642ef499fc079d29a139fb3aee99599a08381eee681b3f8aa5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "00a10a3c70fa0642ef499fc079d29a139fb3aee99599a08381eee681b3f8aa5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7593ecec98e78cfe7b4bf5fae16842c71733dfe9ac612e454b16f418ef1825f3"
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