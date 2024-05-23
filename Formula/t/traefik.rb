class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.0.1traefik-v3.0.1.src.tar.gz"
  sha256 "9f95b4202a94f7c266bcbfd71c73fe1f745c422bef91b30749e18365f551c5b2"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bea8359a829a49e93905f69fdb852275ce149767c39985cf34c3e4bffa6f6e95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c45b8a5a427dc4afc6e1a840a6cb90955a8f0721edbfcd186a48b2bb49362e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802d9a327899f689862709c260a4a24942bfe9184ff8da206e54cdc1486ea742"
    sha256 cellar: :any_skip_relocation, sonoma:         "49a2b903db8c5d5319867e4600bcea66cd84524333aa592895a9fa77c3e9a1b2"
    sha256 cellar: :any_skip_relocation, ventura:        "664fa61df9d3c42c5988be68dbb9bf1a3c1dacdf780dd4cecd6cc88b1ca10ace"
    sha256 cellar: :any_skip_relocation, monterey:       "94e2b27005dc3566787f6c98011700fcd5af79a2536709c3e5bbc3c4fd10938c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d26e97775e2b73671fd073c9cc7b84f14827202899b184756db6c2f9fc59289"
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

    (testpath"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

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