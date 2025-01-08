class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.3.1traefik-v3.3.1.src.tar.gz"
  sha256 "a88f98deabc6b63102dd70daf2a0875897933f892bcd10d9c6ecbb37a390b72d"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5af6a7ba680761c5bfe1432aa2e985e3db6cf382de9c1baeb5306e59d1d82dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5af6a7ba680761c5bfe1432aa2e985e3db6cf382de9c1baeb5306e59d1d82dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5af6a7ba680761c5bfe1432aa2e985e3db6cf382de9c1baeb5306e59d1d82dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee6b767e5ed6894faf5d6223fa6623779a8ab375947618c53a90bce95696c91"
    sha256 cellar: :any_skip_relocation, ventura:       "7ee6b767e5ed6894faf5d6223fa6623779a8ab375947618c53a90bce95696c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1fc5dc5eaa477247a325a08c14e39dae0ed41166f6787e8f74506ca41cc6fb0"
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