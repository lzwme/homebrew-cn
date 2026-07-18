class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.0/forgejo-src-16.0.0.tar.gz"
  sha256 "7115ee14ed843c5ddc5b43ad1f5a448bff0ed6a9401806527a11205e4723f2ed"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f61cd886f5a11cd98673ee820bc4b1355761e346223f6c18fec44c12134d8db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23588f35724a6827e610c40dc0186a23aa6755bb6eb761f5807248fb2f9c39f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48cbff41d4a7f4cf682a0ffebbc15f2d2d8779fbf036d48f0803caefff84f270"
    sha256 cellar: :any_skip_relocation, sonoma:        "988d5eb23b323f3eb6e65dbb9ec45c94e076540a9eafd7288aa3fde351052b27"
    sha256 cellar: :any,                 arm64_linux:   "d1f0ad202c29c7546bdffd8ef60a49dca19cebcc06280f89ed85d3321064c508"
    sha256 cellar: :any,                 x86_64_linux:  "9bf9d3e96442d9215937104462795e194f42af290733ff526b70d012460038d1"
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