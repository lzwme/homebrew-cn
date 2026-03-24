class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "6966511034248e4e9f55c3638ae1218927313206c158f42bb55f88a3cc0cad5e"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c2a677a2d05c064e63be1ea3fd47f407cf18b6794d69ac6d44da89c1debffd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff40153105f30c42097067ed57c3336b0535163fd4a167841817fa20058a6e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87312d0c01e5709ac311198c0ca1de04c3763307e7b6da9926f9132658689bdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b51b49c4d5e85a27badf247fb82054371a3a45b78644143aa6a77306d68c185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "364b188f0dae935d3ba5a8653cf9f13e2aa92bd34ed60dc01aaeba82658cc966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7accf534b49feaa17c18986c09d76424954cc82dd7d7f04aeb8f0b8d0f448dfc"
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

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end