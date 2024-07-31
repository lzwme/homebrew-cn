class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.1.1traefik-v3.1.1.src.tar.gz"
  sha256 "247a209d2090b4f5e6d1524f1ba1c9b0be1eb8e35f7f9f9a50f439e624059d52"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcb28565ae17de180c4438935bc8786165137806a9b90815a7268fdd74c85bba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ac4d20a244c0d0f21b7f5474611ed6630e748a2564232808dd36c07b1ce98f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46040e92938bb4e5c441895372b2b729b2eafdf02b205b174750449106db2576"
    sha256 cellar: :any_skip_relocation, sonoma:         "30bb1968732c0f2d7bb9a10d6cc6b426113e96c46b5045f9192385f3a4e60e2d"
    sha256 cellar: :any_skip_relocation, ventura:        "81bf8b5898ce0bf55f26e8e83d26508c57aa62898e9be98a77ed0ec82173eb40"
    sha256 cellar: :any_skip_relocation, monterey:       "74746e98e81d47d44e39d9b4bc600eba58acf452762a58c25761619dd7321491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81b468d1768533897dec7009dfc4ae5190e769d912f3c44cf618f9aedabeff76"
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