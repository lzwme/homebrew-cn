class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.13traefik-v2.11.13.src.tar.gz"
  sha256 "8fddbac6b73db67ec0ff9d094c247e28f31fcb8bfdc79e302539367f000a99b9"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb45dcd3966cbfb8be4670294427621a8106647e0c8471aec65577515e74ceb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ee3e20708c4a9b2a02d87834783b73c20df01e0de3a8377c7886b04d28f46a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33cfa5da004108ec5c8d1376a8fd90b4238323f7c8d48dc61aebacf5fd10b65f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d16645777e3a6ef5901da3b749038228534791b4a70dbe80840057efbd02c7e"
    sha256 cellar: :any_skip_relocation, ventura:       "d393617dcc1d3f712d115da3940b384703dccfd6b49fb0ad98a2d9573ed13157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490c29e42eae175edc6e9eb3a56353a9825be04d309c5bf8fc5b231b3a3b5572"
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