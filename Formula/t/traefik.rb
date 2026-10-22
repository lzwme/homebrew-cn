class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.7.16/traefik-v3.7.16.src.tar.gz"
  sha256 "3143af8f5e5e624477d6a5ea2dbaae656c6bd0ed700af1de671be32dab06c173"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53462c43e6cb74eeb14a5dbdc252e5f0bbd39b56eff818d527879a162f845d03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "633a8bb2f9eb846e9d1594ebdc8160584f601dcdbe28b626decaf45ec82ced13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e27a7d75a750f4cfb97e436c50bf4de6dd2af4e15d96be6e46a3ccf6d705a18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4026e055f4645e6d230afbfd3b78eb0ad4a4b141d133c86bbc51eb2ab2ce37e2"
    sha256 cellar: :any,                 x86_64_linux:      "6b21266964d4ae39624f44e8d8cdbfc23f895e1238a74b639d8edc052d0a8b8a"
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