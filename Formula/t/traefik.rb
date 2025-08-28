class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.5.1/traefik-v3.5.1.src.tar.gz"
  sha256 "fc5cb4b50877c13ab4a120bbffb0dfd9edd0ec6b15a6901579db2701dec05c5f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c780a93b8b073b22f6d3503d23ea2994178b767de35b57bf0943ef41d77c047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e5e1e4fa3acb8c73a13f098777cdbf571e8711be3448789407526805fab620"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5ab0bd2c2d1c17f1817ef3060eb91e358498eacaf1b5a87228712981c57d2d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f07c42f70b7c33595d7910aaf5113f7dcf9f5dd99b508321a2d8d3c84f0fd3fd"
    sha256 cellar: :any_skip_relocation, ventura:       "4a9709fd5ebc5791840b7e5a52d963ef4af6860adfd3a5f7755dec6636751bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f80077fea543944e3c381240efb4c97f0e3f78afc0bf896eb1fa52b76831325"
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