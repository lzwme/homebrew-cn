class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.2/forgejo-src-16.0.2.tar.gz"
  sha256 "570cb79e92bd2c906c329ff6019cffcb341a5e07ec4652c9c04c57c01beeb98f"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc950120742cf487eb2f0cc3d69ca0b3c4a5b1826f9f91e34f1599b3214c93e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0722208cf85636b063c8660f606171c5a9accf6717333f82440bc02dd31b6ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2b74456d5626c08569f2b35a8e6a00e8c3458d536518380e6c50be2bae95a64"
    sha256 cellar: :any_skip_relocation, sonoma:        "704d88d151e2d13ad16544ce554d7027dbadb077502fa6e230f51093d6f697fb"
    sha256 cellar: :any,                 arm64_linux:   "62da3fc26f150ef13f0931b47bda3701c96e97af474e371cb18b92e10f8515d1"
    sha256 cellar: :any,                 x86_64_linux:  "89a5bd3658ddef4ffaa06460d195a5e75a05d163e05ad0eefb4280a60a38210a"
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