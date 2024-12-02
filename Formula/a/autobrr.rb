class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.52.0.tar.gz"
  sha256 "368c9bd8e044853ba9cf23b9b1db7d2270cc506993c833c64e979032de8edc96"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fab70ce3940f892db46c2efcb0cf3dbeecc3e3546e05e59f76f934cde0ab35d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fab70ce3940f892db46c2efcb0cf3dbeecc3e3546e05e59f76f934cde0ab35d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fab70ce3940f892db46c2efcb0cf3dbeecc3e3546e05e59f76f934cde0ab35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b5fcad1cf1ca8c2472ccbe09e575289c9d60dac5f1a8844428e8dee5f9fa249"
    sha256 cellar: :any_skip_relocation, ventura:       "9b5fcad1cf1ca8c2472ccbe09e575289c9d60dac5f1a8844428e8dee5f9fa249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655d0ccb49ae86eed42eeb6c513dd3b072954ea375787f62cc60c273457dedb4"
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