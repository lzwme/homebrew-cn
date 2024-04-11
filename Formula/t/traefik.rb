class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv2.11.1traefik-v2.11.1.src.tar.gz"
  sha256 "6ba38cb79c9530655b9b8cb66034cebc1436a12c9b23df5534d9a5983b23c6a1"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd76f4ba1011985c845ce28937c52d6e6db8b14f34f1ee442528f1ca9e7c8ddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc7e5f6a8055bf4f9f048a1a5363b9db68dcbb3960fdeb798cb96bf29b47ec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46dc11937fa18cba18421c40c78d82e111754042bc8da0ae30b66e5c0504c5fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd7cada8c86b848bdd5bec3db2dd5e1e9b42baa1a98b0495b173b7888f2c2e89"
    sha256 cellar: :any_skip_relocation, ventura:        "23d4b3c742bda1ea0e3654cf34fdb3e954d36e1ca0153fb21c4f31e93df21a88"
    sha256 cellar: :any_skip_relocation, monterey:       "52705e67edc3a55406d5bbd47d4395664b2bae6b7fb5293a6b8bf0ff66fcf731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88afcea83a862c13751807869afc0d6dc6110fe0b9444e2fe14daa8af3c1434e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtraefiktraefikv#{version.major}pkgversion.Version=#{version}
    ].join(" ")
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
      sleep 5
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