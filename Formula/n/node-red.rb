class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.2.tgz"
  sha256 "a0203340780a07e7214d2e1bc88a575ee431da89a2045665142a9d55f57f79eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "deb69f1b659b48287c5596e77349528a9fc404e04fbe6153cd021048beb2b537"
    sha256 cellar: :any,                 arm64_sequoia: "89c3a639d9ca0b3e41905428cfc31d955a3f32ab815b9b9773f3cfe90926bef6"
    sha256 cellar: :any,                 arm64_sonoma:  "89c3a639d9ca0b3e41905428cfc31d955a3f32ab815b9b9773f3cfe90926bef6"
    sha256 cellar: :any,                 sonoma:        "8e5012ad19cb5f96ae0cc069707c4aed80c8f9cb755a1c42482415ddfa334b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb87981c1c5d1b74292f6f54b4b73d2696d6fdc27408d9e1ee6c5a1d97c6bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f76cda3a6f24146d7ad0ace05f72508e962044f09d85a1b5fdec8ce3e22c79"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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