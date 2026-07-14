class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.82.0.tar.gz"
  sha256 "348544a71fc4f995d7e400378403b326f7af8506303b8e711f07fef10d04960c"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fcd829f0b4cd7bb31a0a8cfcdaea9ecff9983cd7f57a1f541d42fa87d8fcdd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99b56d07be359739ac4bd693c9a17df465d5227f275bea29a6f64c7ae28d1029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8e693962b4835b50ea20b695f24b349f9c6add4b6da00832294262278d20db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a156638b7d41dbe3225dc47a5a2237dfcebbe252275c5c5b84945198263435cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1223018199c7cd35dc90694bed70e442926fd1101d423d74c85c10830864a2de"
    sha256 cellar: :any,                 x86_64_linux:  "041d7b14c9c34435b3016965a9a33f0e340151c4102d6c0d27ea80749578bb00"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "web", "install"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

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