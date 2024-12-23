class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.55.0.tar.gz"
  sha256 "ebcae270534473afd1a73a3422c3f5894a2163f1fdd70efeba300b2f12fb3fa7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c2b5f5156089e076304fea0bf974d461c5eb6b1fd22409dd0f8d5a9fb572f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c2b5f5156089e076304fea0bf974d461c5eb6b1fd22409dd0f8d5a9fb572f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c2b5f5156089e076304fea0bf974d461c5eb6b1fd22409dd0f8d5a9fb572f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7f9d1d674ed3624d9dd196b989c8076c4acbb3f233bb5825dd4028bf06eac3b"
    sha256 cellar: :any_skip_relocation, ventura:       "a7f9d1d674ed3624d9dd196b989c8076c4acbb3f233bb5825dd4028bf06eac3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee88e220721af8006fa6df1735d9eb3f9402ab1e558a6452a350c50ad934518"
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