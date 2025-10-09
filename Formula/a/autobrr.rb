class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "2a3346c628ee039c0cff4159215ace6f1ae7c4524f6331a99f4f91c2c1dfa754"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fae0c3bf998074467d4a4dfb801ef310c6658692f2691bc669c43a1ab8c9481e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aa2555e8976f72c7992fadea4b5453ce3eaba1b03fe9d479db0196a1ecce883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea434c97025e19d272b864104e06121664c75ecb0654a46bece5efb6e1d39e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa2c7dd4f0dca8f72f603549771fe5f5b31e531f373eabf370c5f304a0e6982d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "170679c1ba216a4528662dae201b4c0f23bec749fa80653f846df1dc3cf65884"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"
  end

  def post_install
    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = fork do
      exec bin/"autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end