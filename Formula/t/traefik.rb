class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.7.6/traefik-v3.7.6.src.tar.gz"
  sha256 "bc97effd53f3423cebc37c783472c2d09b94dd90a805cb95e26ded71eb2fc294"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "840b1cc02fd0b035a988fe1306b62ae86c08ee297ec3bff4e2166b4fbce718ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1143b8a526817c8d78a085f6eb34531e94dcc78d868f564468df3a4f08ecf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7e32ecf9bbf2fca902b643e2651a2755483f14d224cea7e67b8bb1a91a90bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c651f3811eb3d6ce66c3dd73d91e810b31febbbc372d29510f16ccbdb4368fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f7f5b409b43e4fde006b23e9b0b36b417c9b835684167fb0c8547ba7e157ae"
    sha256 cellar: :any,                 x86_64_linux:  "71db8ef3700ca8f484338e86adabee9dfe19e1328090b3cfc43cb29684699b53"
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