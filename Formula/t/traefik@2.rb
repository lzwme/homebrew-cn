class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.16traefik-v2.11.16.src.tar.gz"
  sha256 "d5d27b6669b97749f754f8d251f996ee2551505dc3e79ff8b7bbaed4bd89afae"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7ac8d8864d0f98b43a5b16e4c61eb90de8de6df516643430a44259cbf2562c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b138f07b480e41aee12e264cdc0124d3c527cba956ca97089686ce4d6eea4d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03e6c073258466929fdbdbeed024e8ab510893a9e9f03abdeaf47f4e275638df"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb08b243015bc75530185276d42d6747358f75d12f23f895f2f00e17a228e3f2"
    sha256 cellar: :any_skip_relocation, ventura:       "e339debed17787353de01aee6ffca6e325e6436835e111916d6d1e71e9a6516d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6130e2b2e617d3eb3a25e51cb52c283162d2796d5e99ad312f7bcf77b95b30a"
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