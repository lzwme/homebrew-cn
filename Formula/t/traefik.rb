class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.1.4traefik-v3.1.4.src.tar.gz"
  sha256 "ef3c05ff29ff5fa57a14c220c1eff43b2441852d6f2b8f2cc92c7faf39656254"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de72a846c543b86d50b293bc9325f4bd94909aa38f59b670f4e8e9d42b33a498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de72a846c543b86d50b293bc9325f4bd94909aa38f59b670f4e8e9d42b33a498"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de72a846c543b86d50b293bc9325f4bd94909aa38f59b670f4e8e9d42b33a498"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae8cf873e513d8e6e6dc250bea13085e3a667827ba1472c793b747558269077"
    sha256 cellar: :any_skip_relocation, ventura:       "5ae8cf873e513d8e6e6dc250bea13085e3a667827ba1472c793b747558269077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c229674834b85fd7310dfe03751f3f37d43d550972bd0a18335d4f19bd148522"
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