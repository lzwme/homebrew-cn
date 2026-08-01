class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.2.tgz"
  sha256 "255bac831730505fc34ed6379afc209096508c360d218150b725428b88d49fb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65ab1675591b087b50f326eb6c95ee7bf14e57465028e0790d70092b5632bde3"
    sha256 cellar: :any,                 arm64_sequoia: "65ab1675591b087b50f326eb6c95ee7bf14e57465028e0790d70092b5632bde3"
    sha256 cellar: :any,                 arm64_sonoma:  "65ab1675591b087b50f326eb6c95ee7bf14e57465028e0790d70092b5632bde3"
    sha256 cellar: :any,                 sonoma:        "4885ce9d364acddbae70954159eea25a5c592621199b7e94c4f3906c248b9a97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "129d3bcdb614bc5449c4ad363d7a3f4724d366cbc8dc95ddca08a5ec5155115a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a51436f257be3bcf03a72d349975ae937bb3b4f0cd6d8b60a0e75accc46a13"
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