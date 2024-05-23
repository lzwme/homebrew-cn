class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.3traefik-v2.11.3.src.tar.gz"
  sha256 "e4c310103afabff4b0aad615b535a3de2b044fc17984ebae4dd56607386eb36b"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0da918b5bbf66ce4e6acacf38db6cf02d06913d2593568b60395d8e3be43930"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dc42d431fc81bc4a2c83881f7df9ebc09d3f054289871ddb99f44aec6791911"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1439529b0d743ea8e9f7d844bbc24dea1599fb9b3aba10eacc7c222a632e39"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e8f98f4ab4040c214d2bc09b07a7a109729509dad813977c95ec2b154e2fa2d"
    sha256 cellar: :any_skip_relocation, ventura:        "9c099b816d72a147b459ac9094aa0b5b6fda8767cf59ee679c5ec6fbe0168309"
    sha256 cellar: :any_skip_relocation, monterey:       "7e931332e80c24b740cf9fddee56bf2fce8e2b11ce148b1ef2836275d896a500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a695e53baad886a51767dbdc90948c28ac2118d347c3b0e1b78fd397b82a6839"
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