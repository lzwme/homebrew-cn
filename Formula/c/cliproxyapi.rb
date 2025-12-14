class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.9.tar.gz"
  sha256 "cc47045b881ca1da223eed0f5b54a1caa3a7e6aea5bb3f2ad70685acf898b277"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ea34499bea1b20076655660e12b19690485a3ed0985f2e0e6b06864efa756e1e"
    sha256                               arm64_sequoia: "ea34499bea1b20076655660e12b19690485a3ed0985f2e0e6b06864efa756e1e"
    sha256                               arm64_sonoma:  "ea34499bea1b20076655660e12b19690485a3ed0985f2e0e6b06864efa756e1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "52ac3984c621c25545207e7a48888bac7d1427bfe2c68665f937eb9bc8e45934"
    sha256                               arm64_linux:   "12464161839173528518d192276a83445b54d79354ebd37a521700c535ce9616"
    sha256                               x86_64_linux:  "ed8ba9075049968ac73760ffc02dda728eeffbbe6a049666057f23cbb3673706"
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