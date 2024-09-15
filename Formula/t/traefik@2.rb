class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.8traefik-v2.11.8.src.tar.gz"
  sha256 "e95c47584ee9bd041215de0fcf3627215a4ef48a1cca06fdb638132428521fa2"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "539ccc4441133e1e2e070e94820061f9a7edd1e259a9a81bed4212265f57c352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e763d4f0ecc6401d3128fd3c8e27bcf764c30daf101ce9c84f98f398ef548572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03da36cfd4d51683eace476095fdef8a5f24c1b9dc18126b47e95fbdeb7c7df5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "060d93f2519f2fa293af5a5e34cfef2182b066d32c8a1733093d3f421f67a071"
    sha256 cellar: :any_skip_relocation, sonoma:         "f686dc34a568994212435ac77ec4897793a829c4a5a52058b2a802abf5819d09"
    sha256 cellar: :any_skip_relocation, ventura:        "5cab168f0602cc5eb18676da415479975c60b4ec9887ae1619b316d583bcd431"
    sha256 cellar: :any_skip_relocation, monterey:       "efdb850021685ecf3568c8cfb3cf556218aab39876aa65d00c327dc63e1a5df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "550b2e89ea0ec136b929380f3fe23a0ddcffe2fec1d452aa58483fa21ec315c8"
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