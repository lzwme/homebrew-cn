class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.0/traefik-v3.6.0.src.tar.gz"
  sha256 "a9c2c3a0668bcd44cab4141e95601d1f069fbbe1e8e167f97ff2cefb0da6c36c"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78d9e61f8775db90afb0677dd3c2ff22c438ce5b5378c3ffeb927e403d967112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da99d7a9612b408dd587d6d6b9949e7e579c72c07fe0d4de6fd1a2e171d0b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a5cdb37f39f4905a84c87797e0c35b1774dfe6d4c3eeba0a3b77a9c97936f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a890a02c2d5bd2ac12cab4e47d606492285b70e8fdc74807a9f4b404e57d65f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b082e16c07347e80cbc9af2624f67a0d565f2d876392d409db67adc5431873a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed30cf9b0157409fced322e88de8c10f16cb9d03be3e83dd712aaa3ddeae5bec"
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