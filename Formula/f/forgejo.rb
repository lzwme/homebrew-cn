class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v13.0.4/forgejo-src-13.0.4.tar.gz"
  sha256 "812c1d1f7e30170e614ce09406b76a0963068162862a9e3e7ffe3140b0569fe9"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d35c14642a820c5a11b0da44bd4b902f84cd45d97c86b23bbd6663a05fc09d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76bf4f2c1b97927e7502d676a2605efcce39d4f29d22256f1baff3cfe7ccc335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef01a5c15f2fefcec557c0e9e1b7f671e902e20cf843b9c260b485442c5fd01"
    sha256 cellar: :any_skip_relocation, sonoma:        "e64986889309593bce8e189314fdabd24f067b24acd11f5066d935623fc5848f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a9f7b1beadaf8cdabc68994a1c8326eecda510320f475197a52f92e045105b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4a5740e0f2a953697cfe7cac1f0f77fc1141103e06c0b03dd3455aa0e4de7c"
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