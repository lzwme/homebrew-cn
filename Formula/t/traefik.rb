class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.7.14/traefik-v3.7.14.src.tar.gz"
  sha256 "a5c89da12e74890a2b3aeecf46756ee853a6e8c1e9e27a04fa1ebdaefc68d4ce"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1755ff2ebc444e9f2e74ae03ff99cf7da3d8b5ed65df1b9ab7b8faf091aae04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07a0dff342545217c4fa86b5cc669ee0af0b54580a4847e41d256addf6612dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df43b2e1438cbd6c1ee9b1c645839f15dcf415ec5cd620e4467d88ec88167126"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98cc45285f39c06c249f3769b71b283cf32388de01cfa8ea2fc98a3bdcda854d"
    sha256 cellar: :any,                 x86_64_linux:      "d4059747e930fd90d0f5e50ff7bce09b8c13e03916a6806af5141f9f333e125f"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "webui" do
      system buildpath/"yarn", "install"
      system buildpath/"yarn", "build"
    end

    ldflags = %W[-X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik Proxy</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end