class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.15/traefik-v3.6.15.src.tar.gz"
  sha256 "839e604555c52620112f0fe7afd3e8f84d11b74c2c4f355b594ed1ca5341cd2c"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ded6c9a307370999f56733878c9682ab62545dd1e7480378876caf7351e7b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce0845be60f0be6f25fece80a5b056a5292d7a52c972d75c2834645966f82087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf4ad174a850822e7897bcef63169bb807fe809e7cf4d10b0f88401a5b746fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3bfc147768a999fd7d0253bcd3569b64ff8e90f5093d410f2c57855c13fc997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6654cf888c04a5ec48b81a13eb08b98195aab85a8804e7ad6a7c5f657c580d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334e9ec90ef94f584e1f88f07ad8ab8888e62a17ded4a8ea05ddd67731a709c6"
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