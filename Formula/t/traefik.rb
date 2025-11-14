class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.1/traefik-v3.6.1.src.tar.gz"
  sha256 "16a5cb2b4745b3ef3201f4e21a71258fc655c72f42ed09c4149f1071e21fb406"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "975bdbd4ebb9b928ff9238cd9195b09d4ce7cbbdeda79ea6212496ef86b2a445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0986d0e296104359f63bdec8f61f3c250b2efd13555186c71f5d0e66adfdd081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a428d623f227e7c3f3bbcf17046ff813513ed9c94b6a7e4019eb6a2e57831ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9ec4b9be1faf3b27d35f0f1810d32475692e2a28d1e5e9c3b29347a8d3fb4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26abf2f585cdcd3bd17293778c791c0d9ff05466efc7a3e3058bcb6bddbff276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b32e18ab2733da44eeaf346892f24fb711b89d13fb87e0c63e42530f023171"
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