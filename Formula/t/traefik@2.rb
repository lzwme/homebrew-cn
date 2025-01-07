class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.17traefik-v2.11.17.src.tar.gz"
  sha256 "8bf4747d7686626a2c7bc2e1cb7de3166f91b619ef61f3d6ba6a993bdc5b9fc2"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ece2180030ad8f6306559d2cbf485549fc924dcd14c9104946b61b1e24a2c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a56d112434f7e5a9937bf320629c42aeb11a0a337a049db87bdf95d37f0536d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c287cd1ca069bd6d2e6ab0879548594b63bcce9bbdedc183736c44f91b40fdee"
    sha256 cellar: :any_skip_relocation, sonoma:        "864cbba473d3c535ca26c2d6f616e4d3ddc03c139877794ed56e9fa1541021d2"
    sha256 cellar: :any_skip_relocation, ventura:       "8a463f549c0bfe6e8732c4bf053771747548416a5c1e561d132b8458c38c7230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf39632a5fad885a711c9b2b97573ea133ea5f68cd274bd89db86386622ed09e"
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