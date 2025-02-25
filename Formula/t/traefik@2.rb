class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.21traefik-v2.11.21.src.tar.gz"
  sha256 "fb313667271a210a2ba0243c38418183081177a3d809d0787527cf89309a8a16"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb2ef6bc1cb6f5c64570b20867859df92c021050e99e76252a96f7d4382efa4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75db5158ec7df7f88f557f4b845d78c82a4e57cc9d4b9d55670cc7e78a934144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfd3dedec5bf33bc25eea4afc12f11161a2dc65a74a56a0d2aa975656b270228"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d0c5edcbebf71d95dc936a2c568be05da6c5bd2c8f75a7d85ca64532a1b1a1a"
    sha256 cellar: :any_skip_relocation, ventura:       "2f1dfb7bac3b87080b5527dd4f23c2b17fddf6b1872713e4462b97ff8cce9030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f01472f7956ce2f3f7c1a38b4b64236c05514a6dbc7731e32b66ecb7243b06a8"
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