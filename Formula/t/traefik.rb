class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.7.3/traefik-v3.7.3.src.tar.gz"
  sha256 "39dadf53131f42a20f6775689cd1b86badf5a40132b67d9b5130120ca9ad95da"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e93be71060d74e9203b8dca6e9a44381a454ac005ba86586f3f7af0a19340d8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0af28182a2b28123bc421d1b82a6fa4706561fc25fc3d1aa2d7d9ae6d555835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a305e97ba0f4024fc89328546be7d89bb8fb795fa50b47f42fe55ffe6d9d9643"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b992c23202a7aef55b07f7a15bf1348e83ecb3b66fbc952800af8acbb9171c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "423bd44f1162be1f09943d459e05a18b784c178383d3c342f8a955ce6a4e714b"
    sha256 cellar: :any,                 x86_64_linux:  "a3c5ee5d2b2d03dbf68deb2c697c2b6b465a1c854d87f7b0b18b7737f2571eef"
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