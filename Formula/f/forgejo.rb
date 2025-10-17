class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v13.0.0/forgejo-src-13.0.0.tar.gz"
  sha256 "8d38f4e1d801d9cec79bddc42b2c77216d7ab1cb077a781abe44b82359915f39"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b7868864a68679feabf0bfa7c0b6e4a7c423729324d24d70119b5589d1c237b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c404ec524c0ff1f8df5fb973cd0cb867053e51b95b3d75f204bc3c1a379e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a08b11b42a3f12b469f12fd3bb08786d86ef45c41b913a6ae29d9c5b85eee42"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be816323b5e29ce3cfd5d4897d792651d0a8b1c2858f25257d151d1232c63bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79dd91b42580c4726a81c679fe6f4bf79e753178d38bf93f7c0f67593ecdb164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc561caeb5b186185eb7b2f25797bf0f7cab7d4b5e6af610a55f2883cbd7a590"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
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