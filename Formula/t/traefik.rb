class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.0traefik-v2.11.0.src.tar.gz"
  sha256 "b431d4a802d7c06912427b3e876c44fc4cc0284bb05268c466dd6a0fbb59e9c2"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f13a7056c124067ee8398d57f56deeddd80aa7cc93a8dd56a57cee2a24fd7225"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ac06b17e97456139c67a30fa4a271d3f9bdc6cb2ab791ca80d05b18fcc695dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a29a68187cbefd490e39807c08ba0c14d100009ea9411d2abdc61db89d820e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a59a19424956ea1f34f05ffb3f89d52931316cae1e74f16248a5f522fd0fc380"
    sha256 cellar: :any_skip_relocation, ventura:        "1048213e0b0f0a3622139bb4180db1075a10cb459f18bfb77bdb3da2d7957379"
    sha256 cellar: :any_skip_relocation, monterey:       "2c1b0683ce6be34707e9b664311c178e3796130e5b9e8d018b283372cb7d5f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc7ff659896f721ab95083bf8cbea277347cb9ddcdd09adb1468789f739005d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtraefiktraefikv#{version.major}pkgversion.Version=#{version}
    ].join(" ")
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdtraefik"
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
      sleep 5
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