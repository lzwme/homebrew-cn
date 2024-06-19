class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.43.0.tar.gz"
  sha256 "b480cad76fe9297616843f929a0267edf1ffec14defe180935f2d3fefcdab3d3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b5f9f6134a25f54334573f2b20dd1900ddbadce6b31ebfaed97107474dc1ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bddf18134752251e019cc707571e5a7817310f8f28c9a32b498c368f56c4542"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "040d6abdf9c2b49de4c65abda224b08238eed0a80e4c7b992893b4bae44be940"
    sha256 cellar: :any_skip_relocation, sonoma:         "3642a5cc5b8fa1b6e81c2defa313d502b8afe8f35144e388bff076dac1382796"
    sha256 cellar: :any_skip_relocation, ventura:        "ee0ea4d48b6ee377f67887c06ef0693e94ff440bb287a599ea5b246718ae3a8a"
    sha256 cellar: :any_skip_relocation, monterey:       "f73a0c9142b9400cba82153ce7c8150e8b28c516a59c3b3b87fd9472abc10660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "294f4a3666058f7e186f4b8510d9d1c8cbbacd11e6a7b017df9c742f0ff5c633"
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

    (testpath"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec "#{bin}autobrr", "--config", "#{testpath}"
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