class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.4.tgz"
  sha256 "557c1309b2c41a3ba4c5bfbb75723a58f3757e7974ea60702a9d33349592815a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc316089c0f3484cd735760bc86dbb37dbcb97f8a36bac3022aafd9fdd74b5f4"
    sha256 cellar: :any,                 arm64_sequoia: "0a7477cbe696059b11bbbaaef476e839b14c9d823f25596155c103a3e9cdbb12"
    sha256 cellar: :any,                 arm64_sonoma:  "0a7477cbe696059b11bbbaaef476e839b14c9d823f25596155c103a3e9cdbb12"
    sha256 cellar: :any,                 sonoma:        "255d9bd2d12972877be2d1a98856bdd51183b309a4f6226bee1b644b8e937036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ad740923f0560f1e652485295288bbe308fd51c50b5c4ca1a8720d39047978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67d586e580c84aabccc009e35cac8560ad367016f52eb97b32dbd2680fe81c6"
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