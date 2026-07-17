class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.0/forgejo-src-16.0.0.tar.gz"
  sha256 "7115ee14ed843c5ddc5b43ad1f5a448bff0ed6a9401806527a11205e4723f2ed"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bce8db2f0b8956ad63181066c3848802512900c6a5a010df4aaf01ca5a58ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cc7d8de43924bd3023fff3f5a347b736cd99e08505cf8d938149bf8ca4b57a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c272e5722973181c2efeeead7a82e44d693a62c56f3a5a271f422e372598a19"
    sha256 cellar: :any_skip_relocation, sonoma:        "59903b0d64e816ab9f475be8b74412e5f693b20ee7d01accefe8f8c8699e7ff0"
    sha256 cellar: :any,                 arm64_linux:   "6bc04d49040ce0a0998f316fa74aca81def2ff03232070bbad54c0179aa6315d"
    sha256 cellar: :any,                 x86_64_linux:  "84008338ad73a6fd674f62a4ff4ca9b1d86fd3ab3ab996de7c70661a39afca3c"
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

    pid = spawn bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl --silent http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end