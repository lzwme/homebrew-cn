class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.15traefik-v2.11.15.src.tar.gz"
  sha256 "1769ee54983238b00eec611760891ac2c68a1c17b3c816c6fc55b9981166f497"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad025d901c5b3da17f769f77f5c812cf7c41dc44f817691c03a0c048ebabe33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc3c0fcf4e41022c3e52b166f09ddd10644ea7009a9580992c3aa188732e05bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09438e63adc98f72f8c698f9e1db78f4f6924ec6383a319ce40c859c8071b2be"
    sha256 cellar: :any_skip_relocation, sonoma:        "0648025aeba59219c51f2afa2cd9b00ed25ee8635e598edaa0744ea93615bd75"
    sha256 cellar: :any_skip_relocation, ventura:       "04096004d1db71144c82b114bfb0609e81a4fa25bcfd1a30982859ffc6593c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac68c11db4603351879eecd48c3d0c53f6000fdb1d308c4f0c8807436bbc572f"
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