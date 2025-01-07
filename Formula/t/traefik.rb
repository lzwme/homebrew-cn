class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.3.0traefik-v3.3.0.src.tar.gz"
  sha256 "c52a59b51f75f61afcc77fbdd5c8ee7f753e39027848110fdbfc251b38162cf1"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c85c3ad0a996efbeb6e1f3785cb5fac99eeaa4a67e4463ef07afa4fd8b4fb820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c85c3ad0a996efbeb6e1f3785cb5fac99eeaa4a67e4463ef07afa4fd8b4fb820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c85c3ad0a996efbeb6e1f3785cb5fac99eeaa4a67e4463ef07afa4fd8b4fb820"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ac120266c8ce16695bd4cab00a77d3074f98a79a60b5b89a9c0b589cc155fa8"
    sha256 cellar: :any_skip_relocation, ventura:       "0ac120266c8ce16695bd4cab00a77d3074f98a79a60b5b89a9c0b589cc155fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a2cd404770a524b2787b2bff1247c306a4547cde98f201c8463d5252134779"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtraefiktraefikv#{version.major}pkgversion.Version=#{version}
    ]
    cd "webui" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end
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

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http:127.0.0.1:#{ui_port}dashboard"
      assert_match "<title>Traefik<title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}traefik version 2>&1")
  end
end