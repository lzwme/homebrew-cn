class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https:traefik.io"
  url "https:github.comtraefiktraefikreleasesdownloadv3.1.3traefik-v3.1.3.src.tar.gz"
  sha256 "bb0d18ffe6a7be29150822dc86198ab66d448a6513f44b1f6bf5a8987db0e83a"
  license "MIT"
  head "https:github.comtraefiktraefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e314aebd9689992a4c51d12617c8dc49d5d3681ce82775cae6135288330978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75e314aebd9689992a4c51d12617c8dc49d5d3681ce82775cae6135288330978"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75e314aebd9689992a4c51d12617c8dc49d5d3681ce82775cae6135288330978"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34306783e640d383e2ef71fc4f9346968a06912eef14b417884084413ac7b70"
    sha256 cellar: :any_skip_relocation, ventura:       "e34306783e640d383e2ef71fc4f9346968a06912eef14b417884084413ac7b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "594cae1f25fedf884efcbc7b5293c1f818bdd72bcacb625e46b88c1dd795e110"
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