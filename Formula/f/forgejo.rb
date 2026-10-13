class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.6/forgejo-src-16.0.6.tar.gz"
  sha256 "0fe93c0bc4e1006ec3aa7d65be51181cc02efe4974c4237bb23723d954ffa630"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "286e9e07d1025f9fd6953f5f06120b83af3e9bf09b6bca160af8bc0369623f6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e53ff8db08b6bb2760475a950648f7de4a84ac20d26a0f258ec30ff63d7d9dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40548aa503becdde73d93200a487ae99350777631e6d520b95a7d37efd70cdae"
    sha256 cellar: :any,                 arm64_linux:       "2b4126d98fd44fd61d9923f4747e5da1bd43fa5767fa307c5c9c9bb366051aa9"
    sha256 cellar: :any,                 x86_64_linux:      "40abfef27d2241acc55bfdc8b024d4a64bca0f62ffeec940760f7b405858b9f3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea" => "forgejo"

    generate_completions_from_executable(bin/"forgejo", "completion")
    # powershell completion uses "pwsh" as the shell name
    # instead of the usual "powershell" used by generate_completions_from_executable
    (pwsh_completion/"forgejo").write Utils.safe_popen_read({ "SHELL" => "pwsh" }, bin/"forgejo",
                                                            "completion", "pwsh")
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