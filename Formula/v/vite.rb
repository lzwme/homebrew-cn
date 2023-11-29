require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.3.tgz"
  sha256 "c5b620c229af3c71c077225e372f7a7cc9941420f47393bf34f3f398edee8f28"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e75d8703ef785e4dc20ced87966d83316d241b4ba8a543fb326a83bc1e7123f6"
    sha256 cellar: :any,                 arm64_ventura:  "e75d8703ef785e4dc20ced87966d83316d241b4ba8a543fb326a83bc1e7123f6"
    sha256 cellar: :any,                 arm64_monterey: "e75d8703ef785e4dc20ced87966d83316d241b4ba8a543fb326a83bc1e7123f6"
    sha256 cellar: :any,                 sonoma:         "9b6ea809616f93ca311acd87e07b3c2380bbc57b98732037341776daa85b149c"
    sha256 cellar: :any,                 ventura:        "9b6ea809616f93ca311acd87e07b3c2380bbc57b98732037341776daa85b149c"
    sha256 cellar: :any,                 monterey:       "9b6ea809616f93ca311acd87e07b3c2380bbc57b98732037341776daa85b149c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631ff1c05854e2a9783d3b3375542796840673a89ae83aa1f9438dccd39997c6"
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