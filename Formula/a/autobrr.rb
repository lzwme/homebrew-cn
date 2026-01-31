class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.72.1.tar.gz"
  sha256 "7de7d44d0101ee6bda0099694922fc98a57abb3edc931bb2df6599436beeabbd"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "416451ad1a03b9da8f3f35a3b1f9fe6c6c04882e505901a9822e993e3f26964a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae554dbfaf0b7be0cb5a73ac8bcf22c93f0389c160b8d64c22c8858ba441f701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf971c2a9e16c8125773ec05a2ec5d360a7187365684041576dad35312726fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3b71314e89df3e786e38c1076a6e8c964e7663efa9ef7d5b67e5f12d16b54c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5544e608a5542362a39fce3378d109ca03df9bdd415eb4b21ea00a90599312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d714e6d9d982715c450ae40c47919cfab3b8d6d3f65768e8a9f4801bacb1b0d"
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