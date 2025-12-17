class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.5/traefik-v3.6.5.src.tar.gz"
  sha256 "9b6237f050bf8ea5403a7985e0496ba8e1a14a9dbff672e0ed220603a95999da"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24678fece30c4056fdffa6984672048533aa36d190f1303938ceda1e5e31106a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c84902d1d69c7ef29ca39528625d5bfd8d99354bc497c7085ee807f954fc33c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc9ea7a99d029c79b14e2196c0f380e393f2e1481eeab7a4f1df3fb23bcdbce"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed63a2d9a481d7f837b0be85f7ce7983b904640a8c0b91d74ccc669b78f60ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd75d24c1ef53510a3735607c11992a40ac5d938348c5569b1ae6c1ee613a635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95d3a015348a6ab2171a357e906285151f4ae97b130e473b84ec81d0a8e4b59"
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