class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https:autobrr.com"
  url "https:github.comautobrrautobrrarchiverefstagsv1.54.0.tar.gz"
  sha256 "86ce15f0c92ce045c3b07605c62f86801e5abeb9dc6e81d0c5c8d46f192945b7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58212df2281a398eef5eaa2facac5d53fdd56a82e6fc3314e9c149cda92d388a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58212df2281a398eef5eaa2facac5d53fdd56a82e6fc3314e9c149cda92d388a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58212df2281a398eef5eaa2facac5d53fdd56a82e6fc3314e9c149cda92d388a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8099bef60df72c6106fb896c80ad062ea82f542db1639df6a035efb74f5f7da3"
    sha256 cellar: :any_skip_relocation, ventura:       "8099bef60df72c6106fb896c80ad062ea82f542db1639df6a035efb74f5f7da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57a6297c6a72e973e34a1cabf8ada652c1eb95cbbb3601d6afd9a5461c12b53b"
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