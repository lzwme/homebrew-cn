class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.0.4traefik-v3.0.4.src.tar.gz"
  sha256 "6e9fff2f62ea01592e2530f36a7db6bb14cabd5161543d7b01faf48366a0ada8"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c61cf2c67b5121bb52a188c630796dec7353237999e5c8c804202a6765cf511b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e472bbf61543672ef0fa74da14a1136697686a0c8e9c03c21317448efe6e3be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd81b3f7decc29a51f6601895c227eac26f7b34a3c4fa220256ad5db14c078a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5626293c7d41477cf95e327a7d566bf21fd9cf87312e2657b4cd4d8c3332e69f"
    sha256 cellar: :any_skip_relocation, ventura:        "bd7d89e23b3f1efe472e955e85073da40fecda32b6d70679eb6df12fa1313008"
    sha256 cellar: :any_skip_relocation, monterey:       "139b067c3e7adb1acc3d76ce61bad64677a8bc5ef32d166b2ef9e0b8c14dbcc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d363e63696e87799c2b4669631f3b25b3ac213e5792575b1c9ebe9a0a455b839"
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