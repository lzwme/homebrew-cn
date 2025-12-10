class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.61.tar.gz"
  sha256 "51ad21e86109ad68a3922bb1244c1b7840f3b5a89caf061ad1d8f0acf3d9e422"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "633ce936ca81f27a69860c12f29766012138c0cb21c5ef427ef05e519b9ab79f"
    sha256                               arm64_sequoia: "633ce936ca81f27a69860c12f29766012138c0cb21c5ef427ef05e519b9ab79f"
    sha256                               arm64_sonoma:  "633ce936ca81f27a69860c12f29766012138c0cb21c5ef427ef05e519b9ab79f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae2bc5612fb595bf0fcadc920b93db00ac27c4bf3b63d8a63c7e5b808aebb4fa"
    sha256                               arm64_linux:   "bf67528450b23f1d674ae96e68151f98724f167ce6cb6c763a8a821f620e880e"
    sha256                               x86_64_linux:  "f7e0fbc1eae8fdf50961780b52e5efc793fb9131fda2105aca115b118408f3a2"
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