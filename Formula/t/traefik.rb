class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.12/traefik-v3.6.12.src.tar.gz"
  sha256 "42a87c1061e6ae97dabac4142281b151ff5cbc7ce7bfbca4b0f61ee1ae0cf7dc"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fd100930eb4d5b8dd107e630625ac68e831a800beb2bc714651da274c980d6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfbbfef0eb21ee875a363e3c6dd39e73b17af26425ed53050cf643e716a4bee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa57f4ac6ce9013ba3af9e69526622208adb79b5c09ae5e6ea57ae9737a77fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d77676e880f853ff0aaec1ee397f44fcf02a86f78f0f14e17d5909a7e5b355f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "969f214a036bdd6936c4b9b43f83b6533bcc9939d2e1d1430f49e70f9a0e1a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7afdf3a655b866e0c15ced9b4dc4b6327aaa604c079cfdbdeb64772e8486e8f"
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