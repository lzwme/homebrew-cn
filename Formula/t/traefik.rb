class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.2.2traefik-v3.2.2.src.tar.gz"
  sha256 "40564d08776657f323134ebce655457b43b4d415e6dfdaaab569a985648d5a1c"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057f17247baa13c5f1301940e78ab5f40ce055606d6838d85cb74d40874caa62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "057f17247baa13c5f1301940e78ab5f40ce055606d6838d85cb74d40874caa62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "057f17247baa13c5f1301940e78ab5f40ce055606d6838d85cb74d40874caa62"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4a3d507b4949d10e8b601c2808bdcd0a41f4e9444d089ebbfd9e893b470199"
    sha256 cellar: :any_skip_relocation, ventura:       "ef4a3d507b4949d10e8b601c2808bdcd0a41f4e9444d089ebbfd9e893b470199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e42ed9fce0201a10602f2f83999ea1c5d7cb3f9541a621561d3031d7eae57b4d"
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