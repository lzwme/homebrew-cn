class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.10/traefik-v3.6.10.src.tar.gz"
  sha256 "77a39c7646a202005f75b7a188efcb4ea188b5d79f995805ec693b45e043373c"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "279c1fa036193a6abcd05f5e1230cc75e2621f5ef32f941c516c28f9f02dac2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5324d4e93fa062e62c19e42f27b450015cdd2d839f91ece6967e5912ce11ee22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db42263c0d0e25f7f62ed4d3d92c52cba9d0e73bd406f7b28e1389c5bc1d0b03"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c0fd1b7ee0c47f9ab4cce119404aef21f9bfcc58decb93eb37cfa6213571176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6ef5cc2660ba2fa0a6dffa0094b59dc2f405612d546d9f421000c2bdeba9be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8aec18a14188a99c00fb1a0dba0442e40fa3b2aa0bf22ae198b087b8ff615e5"
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