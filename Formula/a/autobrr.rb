class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.47.0.tar.gz"
  sha256 "b6ac646843a05fc81877619ddcafc59ca5a2e00afd914a284861987e8e221f70"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e62fadb98341da92a0c831ff9f223dcc3e1213c38c6b368a5d1d25a67a7524b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62fadb98341da92a0c831ff9f223dcc3e1213c38c6b368a5d1d25a67a7524b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e62fadb98341da92a0c831ff9f223dcc3e1213c38c6b368a5d1d25a67a7524b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebcbd1e29a86f675b3af4597a09aecb6ba80c5adf7e0b953c92f8b02909ec7bb"
    sha256 cellar: :any_skip_relocation, ventura:       "ebcbd1e29a86f675b3af4597a09aecb6ba80c5adf7e0b953c92f8b02909ec7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03d014a2a88debeba26501532a3fd714edd21f3e04d78fbd3faeebe4408e6c4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin"autobrr", ldflags:), ".cmdautobrr"
    system "go", "build", *std_go_args(output: bin"autobrrctl", ldflags:), ".cmdautobrrctl"
  end

  def post_install
    (var"autobrr").mkpath
  end

  service do
    run [opt_bin"autobrr", "--config", var"autobrr"]
    keep_alive true
    log_path var"logautobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}autobrrctl version")

    port = free_port

    (testpath"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec bin"autobrr", "--config", "#{testpath}"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http:127.0.0.1:#{port}apihealthzliveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end