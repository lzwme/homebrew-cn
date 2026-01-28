class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "8ec230aadd6a08491ecb4ba729ae09d1dcc954fcf21dca34114a8d6378848d88"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59071926154f4ae6c07d12671da6eb72e3d32350dbbe4d4c0fe19db122f1ea5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd43647297ba2abf4148ea738d5255c4c8a4532277307d23352a41ed1340b65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74f3440bc57455592095297a717dafa87107b802966798a89778903008cb2c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d39016f197cc9b502ec89217f75be05d962b0ffd95376b548a52b7ea3087bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9d595c2c40a9a79eea623ec8d0a1b3c8d9a4a043fa5acd3d340194e0dab468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576e69c4965bb07762837111d515a6fc0ec1919bbee78b9ed444bf018290a85a"
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