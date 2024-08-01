class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.7traefik-v2.11.7.src.tar.gz"
  sha256 "d25009ab4d5e9be3bbefe1778d3c733379a2ea5d36b47968b2edecabd2975c82"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(2\.\d+\.\d+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03dd3a8d2056ee44b54974387665a2a30b35dc3d73ee51578769d3e97135a15b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2441993670506648bd3c1c3aa0d662d9ae985764ec26a3cb3ba0abf9595b9796"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3222b0ecaa51c7991b3734d1af1e2b788dcf5af28afa2437d5ba0e07f7925d2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7feec2c23e3e2ad00abe2adddbb6a02468a3a3bedbfe1d3fd0a4b7b1c4b8084e"
    sha256 cellar: :any_skip_relocation, ventura:        "0bf30a93201d650bf16ba6f0aaaca12d114360028f468dfe990d02bcf66d7f29"
    sha256 cellar: :any_skip_relocation, monterey:       "1939ad58dcb424e6f830ee250521a42885384f52352187328d166f7237a4a708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f91f449b51f284a6adc2bddf03e5cac275ee9f928f1f2b0eeda6289cebd238"
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