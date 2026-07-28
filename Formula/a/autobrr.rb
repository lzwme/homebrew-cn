class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.83.0.tar.gz"
  sha256 "ed699e24d8ea7105b6879c6240eacc03af220933f54283807642486ba0a7c08a"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8a927446b837e0663489e0fbcd0b541da1badabc3722cbbabc0ad688f759647"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e31b856d5c2ab15f78475ce2d8b62dbb19265c882be085d3a2062e48923cd4ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38d807a1b69a10e9d27398ec0ac7fd51fb2a9ada93385f48bf018b16d783dc66"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a33b6d53461ed3fd896a251a4a086b740f8878fef65686f2e16f12247d3a52b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "135ed45a65416cf01b14536b9b4ea4784418b8c333c0700b95b7faa9f7259bf9"
    sha256 cellar: :any,                 x86_64_linux:  "bcf32956d9871a93d59a2bd3ab225876bc8b9e1788ccdb4043a1fc2680155e1e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "web", "install"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags: :goreleaser), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags: :goreleaser), "./cmd/autobrrctl"

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