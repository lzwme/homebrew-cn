class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.14traefik-v2.11.14.src.tar.gz"
  sha256 "2cc17757fd095f1f86bad2682ccc0c06f189c3c22dd5706654970728e36c9055"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2124ad0dc74e88aa389698ee53728f1ab5e62238893350906ac5d05d762e8a6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48abecaa236a9b3954d09685eedff9c672fff3963092b9302888b1f25d3b04e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25102fd1035e7e2e4aad7f0cf962ae3db673ad7ac58b6a78c0c0e4b6980557b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7365bbf0ecfe62521b5ccd2843e15e2f59d9858457f068aaec63157a3eccd387"
    sha256 cellar: :any_skip_relocation, ventura:       "994056fec7152f94fe73190faa67a08cf09748392a5453ee07e8f2d7558fe1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af42594faf24857eabf5debc0f7f9f8289228933454ee3f187359c9dd32d6ccd"
  end

  keg_only :versioned_formula

  # https:doc.traefik.iotraefikdeprecationreleases
  disable! date: "2025-04-30", because: :unmaintained

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtraefiktraefikv#{version.major}pkgversion.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:, output: bin"traefik"), ".cmdtraefik"
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