class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.2.3traefik-v3.2.3.src.tar.gz"
  sha256 "957997222314116959ce2ff68b261e2b2bc5292566e799dd21e7512b5782feb7"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "682c962bc6d9ab091d38512a3b2e8ef6f171b2da46a1692d191301af9e9030c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "682c962bc6d9ab091d38512a3b2e8ef6f171b2da46a1692d191301af9e9030c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "682c962bc6d9ab091d38512a3b2e8ef6f171b2da46a1692d191301af9e9030c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "92ba05fa9a9657c8ec3a20a7586c530a126201cbfb7d48e66caf76fcd479ca55"
    sha256 cellar: :any_skip_relocation, ventura:       "92ba05fa9a9657c8ec3a20a7586c530a126201cbfb7d48e66caf76fcd479ca55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e84b3a32e720dd7b985c7c1c0bdb550746f201fe9c644a979335670706a291a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtraefiktraefikv#{version.major}pkgversion.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), ".cmdtraefik"
  end

  service do
    run [opt_bin"traefik", "--configfile=#{etc}traefiktraefik.toml"]
    keep_alive false
    working_dir var
    log_path var"logtraefik.log"
    error_log_path var"logtraefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath"traefik.toml").write <<~TOML
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
        exec bin"traefik", "--configfile=#{testpath}traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http:127.0.0.1:#{http_port}"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http:127.0.0.1:#{ui_port}dashboard"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}traefik version 2>&1")
  end
end