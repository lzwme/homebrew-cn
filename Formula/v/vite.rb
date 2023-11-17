require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.0.tgz"
  sha256 "de76095362f298ac15399cea3af028b6cdee5886bfcec13be21adebe5b2cf535"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c00bc3a727aa142f778ade6132983482d52f0630fd02fd34c450ada6307e7063"
    sha256 cellar: :any,                 arm64_ventura:  "c00bc3a727aa142f778ade6132983482d52f0630fd02fd34c450ada6307e7063"
    sha256 cellar: :any,                 arm64_monterey: "c00bc3a727aa142f778ade6132983482d52f0630fd02fd34c450ada6307e7063"
    sha256 cellar: :any,                 sonoma:         "86f25f079d7c53ea9963ddeca5a3de8347f0dbc03e6270d24d745ab235741665"
    sha256 cellar: :any,                 ventura:        "86f25f079d7c53ea9963ddeca5a3de8347f0dbc03e6270d24d745ab235741665"
    sha256 cellar: :any,                 monterey:       "86f25f079d7c53ea9963ddeca5a3de8347f0dbc03e6270d24d745ab235741665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20685ce0e1622fc709d0e47da1900d09ccec67e664adf42ebb47c400884bd5cb"
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