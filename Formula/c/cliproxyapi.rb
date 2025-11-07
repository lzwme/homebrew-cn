class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.11.tar.gz"
  sha256 "c338d30374196556df257f24c254bbd45c89c002ee0564f7097a2d456c34aea0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e657adc908e64652cacce1589e291d310aae679816fdf3665b0e65d3e214b6d2"
    sha256                               arm64_sequoia: "e657adc908e64652cacce1589e291d310aae679816fdf3665b0e65d3e214b6d2"
    sha256                               arm64_sonoma:  "e657adc908e64652cacce1589e291d310aae679816fdf3665b0e65d3e214b6d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "256c68b855480548ad3447e13f6a612573ffa11ad584f6f0950be0f7d08c6915"
    sha256                               arm64_linux:   "523d4cd1d74eb5acdd472dc483f277472b4c40a1fd43a96a2f11707f1eb41dbd"
    sha256                               x86_64_linux:  "d212047e600f9899fc4e6730ddfc56e0664e7ab351206e21f35614015aebdac9"
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