class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v15.0.5/forgejo-src-15.0.5.tar.gz"
  sha256 "1005e5c6f7340e0cd86a7b3f4c34ae5c353fc34d012b6c6613eecfeea3ec8f99"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bf132a7bcbf9d1c115b502b31253fa0a69c903edade9ec9e8690d0c10661023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8bbe815c46b302e1809b0b0b3ac8f7f675cd236bd16c0a8dc305a5d99c202a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "548fd1eace52df1aa45d60043780ac7f431b62a5805edd0d60675f99446b8e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d58446556efb1917c82a237fffa770bbc8d7c61667193c43e26417dad0ea13"
    sha256 cellar: :any,                 arm64_linux:   "d5cd0db97f35c1bd3be474e5e9e2b1b3836330aec93e19ccbf17846358d9c2b7"
    sha256 cellar: :any,                 x86_64_linux:  "69967c80d4be27cb2ef17169057d41d67ac88aeabbecd8685e12e4d6dd9e79cc"
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