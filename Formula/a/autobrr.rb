class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "dc2108ee65149c94a94a88f3f39e3898dfffd61399c287de3c9e175a54b6af98"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6801fa40e52e68c1128c50e73bece28fbc07fe3c7bfe103bf2aa3d1bc2c9039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a2fec06b01deb2043d664ebe14c088a8ebc65233c782c6688b4038a7e5c8d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "965e68a2bf4578b059c0d530d2bb02c5f30a8fa9b6c1117e8acaea9f2fddd1b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21687346284e34f6ceb6eabf350e850b2dd644799e51f73efec1d2929ef907a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6da88524f5d843ebf00771bc8df47d221067159409e8585d34a4655a7d9afb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5547949e84ae33ba69c9416bde3df4c7f7e0e58f20c196d845e5c96a4c53208f"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end