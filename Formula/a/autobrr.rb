class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.49.0.tar.gz"
  sha256 "dace7c643c7b799163aa05d5bf60865dae10de9754508042ee77267f42792849"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23197cac96fff78b77cc4e0e348037c4d375717b8b5a961c759724f9d2148950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23197cac96fff78b77cc4e0e348037c4d375717b8b5a961c759724f9d2148950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23197cac96fff78b77cc4e0e348037c4d375717b8b5a961c759724f9d2148950"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2bfc2573099d5f00c8d517100a2e195779363dbf1cb5882f63afc95e9e751d4"
    sha256 cellar: :any_skip_relocation, ventura:       "d2bfc2573099d5f00c8d517100a2e195779363dbf1cb5882f63afc95e9e751d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c6ba864efcd141a1b149b32f70f64ca17fdfdf2e14a9b5f1fe4762652734d9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin"autobrr", ldflags:), ".cmdautobrr"
    system "go", "build", *std_go_args(output: bin"autobrrctl", ldflags:), ".cmdautobrrctl"
  end

  def post_install
    (var"autobrr").mkpath
  end

  service do
    run [opt_bin"autobrr", "--config", var"autobrr"]
    keep_alive true
    log_path var"logautobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}autobrrctl version")

    port = free_port

    (testpath"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = fork do
      exec bin"autobrr", "--config", "#{testpath}"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http:127.0.0.1:#{port}apihealthzliveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end