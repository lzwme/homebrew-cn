class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.11traefik-v2.11.11.src.tar.gz"
  sha256 "a95ee24447b60581a372e568eb6f5f1ea3983ff95c9b2757ed648cabbd6ad448"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dff862feff1b53b32913f1eb484b9faba94529a2d3cc358cb8d34e6dba80ff06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb5b69505d3cf171c5c53cfc98d19ffd2fbf2644644dca8027245d499fb58e85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f55b57795f0fe90e2020390ae99be927de56be2ab3464b96c6f319329083ea82"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fa00dddcc4a33dfdbf540ad9061d7d8af4a4a2ba68f7550d385e0a81f2c2042"
    sha256 cellar: :any_skip_relocation, ventura:       "0683f5fabd4ec75b0f6713c64a567cea07f9cee886ebee84e76df8c0dc61b6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a7b0898ba777cf1cae1d65936fe4e104c0953a3f9b1e2de7db988e60d989d94"
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