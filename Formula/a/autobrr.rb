class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.63.0.tar.gz"
  sha256 "e2a93f9981286b0904eb2ea58473a36206117dc7235ddbf03b55bc6a73386504"
  license "GPL-2.0-or-later"
  head "https:github.comautobrrautobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bb15a320662a786cf2091cbe10db455a5dba1feca74fe3ff9cc2b4ec01a6614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3101d0d8cefbbf2e7731f5d0b2ad739bf043b96d8d10eaf66ac5645df0e40771"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b16bcf9516036b0dbd50e07094585eb81b5e9f411c7b1a64d7a728578e0154cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd628cf7f67e6a28099feb57f07d640e8b8958a9d26c9cfeeb86dc1c7a8c0f35"
    sha256 cellar: :any_skip_relocation, ventura:       "dfd52753f830b4ebb1f8a3a67be407712dca3afe72dbd3fbdc0a122f2caceb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07bebda5775a27e448f6b07df1f81ba2a62bb440cd89cbbda995162ddf47c13"
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