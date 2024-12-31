class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.2.3traefik-v3.2.3.src.tar.gz"
  sha256 "957997222314116959ce2ff68b261e2b2bc5292566e799dd21e7512b5782feb7"
  license "MIT"
  revision 1
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4278eda8ff317f2197e0dd4b3dbf7930347353b6d87b2eda8102f1fa95d53cc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4278eda8ff317f2197e0dd4b3dbf7930347353b6d87b2eda8102f1fa95d53cc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4278eda8ff317f2197e0dd4b3dbf7930347353b6d87b2eda8102f1fa95d53cc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "49637254a846716d29d7ff3fe4b6541fa4cb6fda3b4d82abc5327a9572f93ef4"
    sha256 cellar: :any_skip_relocation, ventura:       "49637254a846716d29d7ff3fe4b6541fa4cb6fda3b4d82abc5327a9572f93ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3734b0968cb61e192907d5bc9fd201ecd45cec2ddde2a3afd54e4abd638a9c0e"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtraefiktraefikv#{version.major}pkgversion.Version=#{version}
    ]
    cd "webui" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end
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

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http:127.0.0.1:#{ui_port}dashboard"
      assert_match "<title>Traefik<title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}traefik version 2>&1")
  end
end