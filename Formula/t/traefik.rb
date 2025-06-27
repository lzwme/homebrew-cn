class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.4.3traefik-v3.4.3.src.tar.gz"
  sha256 "c901e670ce82b733978392cd48951c0770b68b9865e68f02966d17325b9ab7e4"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d90ff9dccb773fa5fcf82f95b6fe4ca5714427b08715597a57735f151ca91ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d90ff9dccb773fa5fcf82f95b6fe4ca5714427b08715597a57735f151ca91ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d90ff9dccb773fa5fcf82f95b6fe4ca5714427b08715597a57735f151ca91ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "21697aecb02e618c7ff3b7dda8bd21ac0741bf025721c0c1814426879e3bb6ba"
    sha256 cellar: :any_skip_relocation, ventura:       "21697aecb02e618c7ff3b7dda8bd21ac0741bf025721c0c1814426879e3bb6ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49f4d03d3706ff1caf314076b07087f7a856cf88f1f0cd8bf3a9e0f681e2e2f"
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