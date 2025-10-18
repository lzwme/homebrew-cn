class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v13.0.1/forgejo-src-13.0.1.tar.gz"
  sha256 "98cb495cd07881d90aa32cf143facef4abba2b732684ab1d938af9fa3ab12f26"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62abf4e0df01d34c46d20cdc90683bb79de25647f6b6f40f910093eb94e56512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d9021d3c84a0d074bbca057549cc424dcda1749c9510d1b52422c65c333ded"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c64e852fc07e60753f165975fe91481fddd7d3dd38792c883ab22af892a5f08"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12fd2fa0455d45a448bd5e9d5de2c4df4eb65d2b3b54f63d24416457bf27f1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c73add6c5ecc35af76a5cd122b98080077e80c817a8c741fa90f479ef8d42c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d07d209a004a5d946043564705c80a1e33bc3f91bc97731615bca329db3970"
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