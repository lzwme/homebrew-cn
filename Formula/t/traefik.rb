class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.7.9/traefik-v3.7.9.src.tar.gz"
  sha256 "e3f77af6c18fd72abb000c4aa6697f1f51df9e8b2470b0ca9cdb772bf2cdcff3"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9227d2830cebde833ad31dd9a61d5ecd4883ac1b3ca9e6d9d7c4888e9a21f83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "431371306d4abc59fa8a7e67bb793f8b9fc5c54aab8c2a93ae8a582d89e4aa4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d884193fe556ee32290d08e0ab9fa500349947a651b8cb45b9c4c983d66da5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2015928631a181dc651473c9a80b68b333516ae6a3220b8a01865507159b2869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcde88eec8638aa3c9bfa33f6df3a80a2b979533b14fdcd7284ac92ec6ae5f3"
    sha256 cellar: :any,                 x86_64_linux:  "30a8a220e706338af218751967b52e37c32eeaef2529c965a10caa0ac52d287d"
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