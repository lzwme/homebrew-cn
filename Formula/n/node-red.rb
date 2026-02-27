class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.6.tgz"
  sha256 "ed00d8333ecdb13df99dc37a1babc81c238ae3811edb7cdb2698beac3d1c6f4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "325d56746dab672ecbd4326ebec48e2478cbaa1d46612c50a818b5fe1131b089"
    sha256 cellar: :any,                 arm64_sequoia: "71bbc62a116e9c5fbb9b138a0dfbfc10b0b7225c1b78edac21bf26f7c3a5de71"
    sha256 cellar: :any,                 arm64_sonoma:  "71bbc62a116e9c5fbb9b138a0dfbfc10b0b7225c1b78edac21bf26f7c3a5de71"
    sha256 cellar: :any,                 sonoma:        "362159824cb13e87514a8d248e6590f3e5620b81b392dcb6b20044407d7a8a6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb2dbede797a78e0bb9ccb4a8dd73bb8fb0338d02eb6ba4d6930fd1479afc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5027b27af02024c5ae790b617c31269d7b763291c072192c2de61c8080e20dfa"
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