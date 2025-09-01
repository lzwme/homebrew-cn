class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v12.0.2/forgejo-src-12.0.2.tar.gz"
  sha256 "eb34c79dba4b6dac05330eb875a58e804b4c290854b482750d27926a13263087"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95ff7291629ec00af538d545585c4f8462707205ac98c4d7523e39a53dcb9f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e9e6165c1a71e414db8f61465c5a97ef61586e8a12000e03a14a16531a178ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a2abfeba539ffc861c2213c4c9784a35d5abd7e5a57b9408eade2f195126289"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b28993d6e464a0866423b4ad2327c3695617fa7d37f406783443dc7ec0ca42f"
    sha256 cellar: :any_skip_relocation, ventura:       "4338d2a5d5d7dca46a7aaab116732c586dad0f05af826dec60cf187498de87a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95d06496d8c3ef0acc293ebe9f76aa46e02701173ca5afdf8ea9d105fdc1ff37"
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