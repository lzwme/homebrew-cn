class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.7.10/traefik-v3.7.10.src.tar.gz"
  sha256 "31e0e2fbdccd3170b3bc5c3d233a08585bcbc5ede8f753d12a5999d69c21cdd6"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7abc9213d9a2f66e956b4f642f50647ed1be7dfdec2a7fbe45a1fa21b9ed4937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6867be4f3faf82db50b549bf1da44bb8eec5f360ab099654d7123bbbaf5d0590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a0f95f8a0ee07c28baaf303b488bc5a1c975c4880806e48e638c5b17487b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c80b53578a5b75a49fc5a0cffa0d52feefa48c1bec81083a6780ba7bc50899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a804b98e3297131a59e26a02e0ea33d3944a5e7b6bd9b1f068c50df5f2cdb54"
    sha256 cellar: :any,                 x86_64_linux:  "86d7c4f6e98bc6a134d069d788f3071e4f5c4685e5e608182f2d86c4f70a3fa4"
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