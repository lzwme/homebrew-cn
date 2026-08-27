class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.7.12/traefik-v3.7.12.src.tar.gz"
  sha256 "2626c9a767fea03f22870f6ba28b550e8061fb6ce4a563839ef8e55a206c20d3"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4028d3265814eeae60a88ef5feb7275c94b1958164b6b034ea9925b2437acd2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c65d6dea7f54ee0168c6a228e9f83751341e455cc0527ccd106809cbb63ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247c531615c9842a2ac52c0b62ad719529c6be9bcd456e170beb3d53a438e479"
    sha256 cellar: :any_skip_relocation, sonoma:        "51432af9e739d35ccae5dbddcdc1214e7f73938fd13ee2c900e6722fe264de63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f725ccbb80a293d58747388e2db9060bfecf406fc87a6cc8c426b312f5e41737"
    sha256 cellar: :any,                 x86_64_linux:  "e80513f53f5e0a5532a642bc45edc43381e67001a37922d76d643fed224222d9"
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