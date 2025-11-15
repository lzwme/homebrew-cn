class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.43.tar.gz"
  sha256 "db9b1c025a7c4701574040ca09368646a42b956bf21d002c8fd5ee232bf14444"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c416dc6b716598468e8a5e85022960b243aa232fda0eb8fa2c27970c64138ef6"
    sha256                               arm64_sequoia: "c416dc6b716598468e8a5e85022960b243aa232fda0eb8fa2c27970c64138ef6"
    sha256                               arm64_sonoma:  "c416dc6b716598468e8a5e85022960b243aa232fda0eb8fa2c27970c64138ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e01ae9ce91e0ff77ccec8000f3bff0eec5a8b0521270b8ee2362060517bcd5b"
    sha256                               arm64_linux:   "452620acccc84572eaca6ada58a7fc0bfe07aa27d046f1c2b2aa9763228f92e7"
    sha256                               x86_64_linux:  "097cfec6994b48258731a6af7d7072ef96f7801d085f221ae1ea0bac4d80e4b5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end