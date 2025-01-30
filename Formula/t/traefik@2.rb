class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.19traefik-v2.11.19.src.tar.gz"
  sha256 "1d9ae2dfedc9000b16b7c0626f61a086194a892bb3e5120a9a3a29bfe2c637d2"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db439b9b6a43a4033767430dde2ff72e902262665f695a66558eeef6ef0591e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65f550503eaa8ddc158cec6ed7bfc01b017d69f77eb88e3b97d5cb648bdc02e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c63c4bc8833fc9c83b53b26edd7a13a62f61c9393595cb8311ac3d55d1bc498e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f13a1f3680fd55793b43f9c0d75c1a67461ebff88a183340a5326fb90a261b20"
    sha256 cellar: :any_skip_relocation, ventura:       "988e0f212cab0bc891b5f174cdd1130bae31695a596c9d21a644209c48076e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca62f71598b0cf6b1a2c6ef970f094feb9b997e7f684a3f0e205543c42af6e9d"
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