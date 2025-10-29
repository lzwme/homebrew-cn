class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.5.4/traefik-v3.5.4.src.tar.gz"
  sha256 "27b7b9c475ca9d83385c4a135b278699e45027e02721e2b8453928d982914579"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c217efd27bd55e2a972ea96d4d19684ff59fbd20aa1a877ec0ff59f540d7400a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1241ab0e721886c8db7d9f5f5537aebbd94965fad6b5c4f901b82ea2178c3ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0631e884a6486d36d3685f497f3d5b12e3ee6fb494398e289885ebaed7e8f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "178f20538af9d90aa07fa80e4a038ba44f10641dbdcf9cac4aa4c80dd4db381f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd16c147969f5c8d7d1bab3b499536d55045064ea0c7f51a8156ec4f4b3352b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b304cd0a52e9cdc461305416e9bbdde1e2b3396a81ff8da1c04c4800f7480b7a"
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