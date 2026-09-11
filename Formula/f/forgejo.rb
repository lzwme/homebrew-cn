class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.4/forgejo-src-16.0.4.tar.gz"
  sha256 "13c5d34ff00cf24e8dc27d9b4df69d1e85263398c56ccab3e944ee8b0bb89ab2"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c52721d0059a0228bfb2e519faef4831c0e71f348766b7da722673f560dee492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4140b88f14f32f4eec705f1d773f88a68c8cb26fd7aa10141e857dd156fefb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09c0affe2d857a1263b58a04e68fcdc4d1c8d99d151dab5587d6778733bc02f0"
    sha256 cellar: :any,                 arm64_linux:   "d4c123d2b49a4feedd8a5f6d3116f9920912f8a776158e2352c7a87175c79c2b"
    sha256 cellar: :any,                 x86_64_linux:  "2746c3f8659cbc80b544ecd722c172eb9ddc5644ca995c90c66ec6b8d4118f9a"
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