class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.5.0/traefik-v3.5.0.src.tar.gz"
  sha256 "e5db23a9f9b8bc2c3a334fda83ba8291a8246e9d37f4e332f02fb86c5db6f7ba"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed2f1dfb7dada7d39d7bd143db13cef33dbd1c6895bfad462fed51eef07967d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed2f1dfb7dada7d39d7bd143db13cef33dbd1c6895bfad462fed51eef07967d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bed2f1dfb7dada7d39d7bd143db13cef33dbd1c6895bfad462fed51eef07967d"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d9a31f3894314d9cf8bf87277953ef8e5df5c93e5c208db92d1f62ddff3d44"
    sha256 cellar: :any_skip_relocation, ventura:       "34d9a31f3894314d9cf8bf87277953ef8e5df5c93e5c208db92d1f62ddff3d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc539a57b941be6d2244a7eae31893cacf3091e9da70718780484ac4bfee065"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "webui" do
      system buildpath/"yarn", "install"
      system buildpath/"yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
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