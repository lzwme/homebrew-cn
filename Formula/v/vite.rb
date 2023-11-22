require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.2.tgz"
  sha256 "916f9f9f1768a532f192e698c387371e5d78caf05679c3c9b888eaa4f6a0e523"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "492113576952c21c446129d5dd097d4b483e8f498335cb0516b362e0c226eaf6"
    sha256 cellar: :any,                 arm64_ventura:  "492113576952c21c446129d5dd097d4b483e8f498335cb0516b362e0c226eaf6"
    sha256 cellar: :any,                 arm64_monterey: "492113576952c21c446129d5dd097d4b483e8f498335cb0516b362e0c226eaf6"
    sha256 cellar: :any,                 sonoma:         "295e1a62bbd82bb6522d6f765f3a090e4b905af878d2865ca38ad7c0a78172ae"
    sha256 cellar: :any,                 ventura:        "295e1a62bbd82bb6522d6f765f3a090e4b905af878d2865ca38ad7c0a78172ae"
    sha256 cellar: :any,                 monterey:       "295e1a62bbd82bb6522d6f765f3a090e4b905af878d2865ca38ad7c0a78172ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546cc4fa9048f5b0a0773c909774335af2f2a106714e22f607108236c5fc0913"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/vite/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    port = free_port
    output = ""
    PTY.spawn("#{bin}/vite preview --debug --port #{port}") do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("no config file found", output)
    assert_match("using resolved config", output)
  end
end