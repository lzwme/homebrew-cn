class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.2.1traefik-v3.2.1.src.tar.gz"
  sha256 "5867a58f5bc5379d31815a038fad3fc05ed9cf25e170dd8875052cbedc18d400"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed127ae0db1f797817c773f28ed13da02fd3ada41fb0560ab6a15b16424cabb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed127ae0db1f797817c773f28ed13da02fd3ada41fb0560ab6a15b16424cabb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ed127ae0db1f797817c773f28ed13da02fd3ada41fb0560ab6a15b16424cabb"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c5b28911f22e629732e2b2e90b249e6d3c78464003eb47bec4d7b2d9e2da1e"
    sha256 cellar: :any_skip_relocation, ventura:       "64c5b28911f22e629732e2b2e90b249e6d3c78464003eb47bec4d7b2d9e2da1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946bbd287afdf5757130c72d5420d048cf519daf24b7d53fbb0481f78709b11f"
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