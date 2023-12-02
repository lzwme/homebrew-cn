require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.4.tgz"
  sha256 "e47e79b2991bb05dd2c10982b5dd1280a4005ceee2f6c2a07ad776e08f6e032d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94ac43c74bd49352cc8c678fc8364af9e0295b15e4ce7b8a1d1b7cc918da3c4c"
    sha256 cellar: :any,                 arm64_ventura:  "94ac43c74bd49352cc8c678fc8364af9e0295b15e4ce7b8a1d1b7cc918da3c4c"
    sha256 cellar: :any,                 arm64_monterey: "94ac43c74bd49352cc8c678fc8364af9e0295b15e4ce7b8a1d1b7cc918da3c4c"
    sha256 cellar: :any,                 sonoma:         "d6729f3bd0ece4c515a6377f068e0e19f242b96e5aa87a66f0df1fa4fedb9d38"
    sha256 cellar: :any,                 ventura:        "d6729f3bd0ece4c515a6377f068e0e19f242b96e5aa87a66f0df1fa4fedb9d38"
    sha256 cellar: :any,                 monterey:       "d6729f3bd0ece4c515a6377f068e0e19f242b96e5aa87a66f0df1fa4fedb9d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298fa0477a95e79f2abd532d5a61a134e94dac8f5360e878e4b953bf8aa2cd6a"
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