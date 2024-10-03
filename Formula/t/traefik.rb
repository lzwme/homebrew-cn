class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.1.5traefik-v3.1.5.src.tar.gz"
  sha256 "e24bc9a521c38ba1a4060dc8f2d5397d5a5cb01bbf363fa079ceee2f11653e87"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50fe914c4f3f7c7d7420de6655eee516e6f865e4f20437532a29b0225b3f2578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50fe914c4f3f7c7d7420de6655eee516e6f865e4f20437532a29b0225b3f2578"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50fe914c4f3f7c7d7420de6655eee516e6f865e4f20437532a29b0225b3f2578"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf240579fa0f0d14bb3a23295ad5894130260341ccfe5c55013095ae6de87a0"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf240579fa0f0d14bb3a23295ad5894130260341ccfe5c55013095ae6de87a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba66c9334b9ecc202000662480413cd73f249638e5c9c6e579259ccc392d1183"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtraefiktraefikv#{version.major}pkgversion.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), ".cmdtraefik"
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