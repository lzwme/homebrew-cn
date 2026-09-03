class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.6.tgz"
  sha256 "bc37ccced0441d6d4b24e76dcdabef89f02c5a10a96cf8f623e5b0eb5db47352"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae4750e5cd09dfdf8709bfec924ade62736d6e315c7f262067e7b77dc43d1dfa"
    sha256 cellar: :any,                 arm64_sequoia: "ae4750e5cd09dfdf8709bfec924ade62736d6e315c7f262067e7b77dc43d1dfa"
    sha256 cellar: :any,                 arm64_sonoma:  "ae4750e5cd09dfdf8709bfec924ade62736d6e315c7f262067e7b77dc43d1dfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e28fa1567e2703206e7fe0491fc7cbdca3de6e86bf037731cda256d666a438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5197f1206c4ad341f288ed43d39586d067cd8837c552e243b0bc522bdb9c9ff5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  service do
    run [opt_bin/"node-red", "--userDir", var/"node-red"]
    keep_alive true
    require_root true
    working_dir var/"node-red"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/node-red --version")

    port = free_port
    pid = fork do
      system bin/"node-red", "--userDir", testpath, "--port", port
    end

    begin
      sleep 5
      output = shell_output("curl -s http://localhost:#{port}").strip
      assert_match "<title>Node-RED</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end