class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.6/traefik-v3.6.6.src.tar.gz"
  sha256 "33224014d6488f5dca817af4ee7aa82b23353b50026fcbc6ba2089b1231ab735"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d06b0ff6a4a56d0247d29450714e9e8d433bfbc67af1db12658f64974fd38ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06ed9a6a76c47918bab7706690c4ca1e955c01adb357c35afb74dbc537e00af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14caa96f00ded15c894c9d4301c4eef6b314011c46185a12a159683543428e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "20d8de9ecc78555947f83d02258b1a0b4d79c743171c25fe911170507318a426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5475ffd5ffa15ce741669778dc3e637ab9bdbd0959a0200b786de2bac7d8daec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "715600e17a9fcd1e512496d3b41ff003379f9e319ece17566deba2d15560801b"
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