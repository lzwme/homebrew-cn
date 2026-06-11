class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://ghfast.top/https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "c61edee82f9cd7ac0137b883ef61586e0ff89fe8358dfc2763ea6cb515f8d56a"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbc54547e038cf68d0c97b90abeaf5825a0432727524ebe5943263b111e99737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea630f24e2ef7446406ad64ea58b5c980b49b3113064878fccf6f43d7c66a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5faa907d0adc27291b40006e87cba9583ff781d31173806e4fc8a37c9f4dba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "be5b81fc677197b00944a3ae6e12c6ba3f04327e6271ba187c5dc18bceceb940"
    sha256 cellar: :any,                 arm64_linux:   "834c09f3550ac4e7b6649e0372490928e7460efc2dfa53feefe7b138cb912945"
    sha256 cellar: :any,                 x86_64_linux:  "e57c30f27ddbc59171c3a4c81762bd10302e113e8a712ba8f76bdf2b1c1625c4"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", Formula["zig@0.15"].opt_bin

    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"herdr", "server"]
    keep_alive true
    log_path var/"log/herdr.log"
    error_log_path var/"log/herdr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herdr --version")

    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    ENV["HERDR_CONFIG_PATH"] = (testpath/"config.toml").to_s
    ENV["HERDR_SOCKET_PATH"] = (testpath/"herdr.sock").to_s

    pid = spawn bin/"herdr", "server"
    status = ""
    10.times do
      status = shell_output("#{bin}/herdr status server")
      break if status.include?("status: running")

      sleep 1
    end
    assert_match "status: running", status
    assert_match "version: #{version}", status

    output = shell_output("#{bin}/herdr workspace create --label brew-test --no-focus")
    workspace = JSON.parse(output).dig("result", "workspace")
    assert_equal "brew-test", workspace["label"]

    output = shell_output("#{bin}/herdr workspace list")
    workspaces = JSON.parse(output).dig("result", "workspaces")
    assert_includes workspaces.map { |entry| entry["workspace_id"] }, workspace["workspace_id"]
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end