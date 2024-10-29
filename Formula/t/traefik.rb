class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.2.0traefik-v3.2.0.src.tar.gz"
  sha256 "2c9a788a6207350999a49cc086e456f1287233df3000a25e1147d7b935dc99f2"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb7529c1012490fc8fc982c77ac7d6f392517c4842b93cd7c8adebd52807864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb7529c1012490fc8fc982c77ac7d6f392517c4842b93cd7c8adebd52807864"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbb7529c1012490fc8fc982c77ac7d6f392517c4842b93cd7c8adebd52807864"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e70e55569765e180baed465766344a11dc5c6c324bad26ca2f8fb22d686522"
    sha256 cellar: :any_skip_relocation, ventura:       "10e70e55569765e180baed465766344a11dc5c6c324bad26ca2f8fb22d686522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5784741a1b51a5b8264a3a20db8c9b1812f26e03d3f2712f1ad6f131c6b1d5e1"
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