class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v13.0.3/forgejo-src-13.0.3.tar.gz"
  sha256 "2054f0dce0eb8be6e1a8e765d931ee515241e09fe6928ecbb698447c73c11e6f"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bfd47218df8a28920826f97333a7dc0797fb35dd1982121c26438848d3afdbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3242d2ba011cc97da8d4afb4c94995891d283d37f08c9e30c67716658e20be51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3aa8fdab919b4185a1de136cfb2d61b3ba5a1bda4d9f9e0e1a646897918e0fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "24cad74f8139fe903709e767eb17e66cec6176f7696cc1dcb7db725898aa3b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb2e3f00f5f820c400cfbc43ddc6a5115fd87bc93946988916e876bad921b450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa4a6dd73e3d33feebc0560156d007b55630d001ecd27e8325a36be82d050042"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea" => "forgejo"
  end

  service do
    run [opt_bin/"forgejo", "web", "--work-path", var/"forgejo"]
    keep_alive true
    log_path var/"log/forgejo.log"
    error_log_path var/"log/forgejo.log"
  end

  test do
    ENV["FORGEJO_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end