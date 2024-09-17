class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.9traefik-v2.11.9.src.tar.gz"
  sha256 "3b955575cb175f17c30b56af6c43882f543b2eac773ff3245d757b8ed77fae01"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a3fa633fc0641642cdf49e3979fb4c99fd1aa0d709ec64f3536dd136a352f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bbf9fbd68f05a8cd10331381114726bb3e572c61ccbea3a1263856d64d17cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c636702621f20b515565f27f5b48864f5cc18c36a8abe9fc70a362e97126fea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5d2a1a8167116aec0252b00213b03e5e372e2b5111752a807a94a7b6b3019d2"
    sha256 cellar: :any_skip_relocation, ventura:       "c91181b656d8db3c41cd9b5babb4177c2f13cbb9e006c40e9199e3381f2f5cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410ec23bf8f540278212867e46cd44c0d7bc2c1e12befda451836966021d68ba"
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