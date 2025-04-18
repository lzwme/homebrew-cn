class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.23traefik-v2.11.23.src.tar.gz"
  sha256 "1d0ee3146096807e2356db61efb97c3283b9c6e24514413abdd77cc0abb61f44"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a743d45e94e590606c630b91f53312702eef696f836439df91ef289476aefaaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fab1b8c5d9ee9d3091e88bb709ee2222e5600bc4c1e1dcafe721d84069027cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a0323ab9010a20defcfa3b6361cd830e3008ac5fbe3514a678a7134c432545e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d84fc3b7d27702b0183dcf0ef53b6e88f37157c76b801676e8e6cb40e3305989"
    sha256 cellar: :any_skip_relocation, ventura:       "eb9d3f65402435ee0321da1794733b3f8d6e8a8af0d8dede2d198e0e9db78805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e4e425af9414a693a1e828d3a2d48114af827294fc87d86a3cf470173d3a8d7"
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