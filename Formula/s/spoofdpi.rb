class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/releases/download/v1.5.4/spoofdpi-1.5.4.tar.gz"
  sha256 "327ec13d09be41b809403a9af6174071d848fa848d36a997915a1689a215b6e3"
  license "Apache-2.0"
  head "https://github.com/xvzc/SpoofDPI.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9cd37389ddb94e60a2bd137172d5c80f67c4a697ebbc9a1513ceee87933ed25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98eb2188407207de6ab2ec5f95a78ac873a68f464978c78c7354add8ca3771e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62279c302bf970193c0246a39e51c54d9b2439d64290ac3e65bbde8323749099"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "111bb383243e3820f0119a82b93e27a82a4b984cc1dde48fc6a11e977961360a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "858cd0ffabd3bd7c335a16cd245bad85fed38e91dd7abc369e21416346fd00bb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Disable CGO for Linux builds
    ENV["CGO_ENABLED"] = OS.linux? ? "0" : "1"

    # Prepare linker flags to inject version information
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.build=homebrew
    ]

    # Build directly from source
    system "go", "build", *std_go_args(ldflags:), "./cmd/spoofdpi"
  end

  service do
    run opt_bin/"spoofdpi"
    keep_alive successful_exit: false
    log_path var/"log/spoofdpi/output.log"
    error_log_path var/"log/spoofdpi/error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spoofdpi -v")

    port = free_port
    pid = if OS.mac?
      spawn bin/"spoofdpi", "--listen-addr", "127.0.0.1:#{port}"
    else
      require "pty"
      PTY.spawn(bin/"spoofdpi", "--listen-addr", "127.0.0.1:#{port}").last
    end

    begin
      sleep 3
      # "nothing" is an invalid option, but curl will process it
      # only after it succeeds at establishing a connection,
      # then it will close it, due to the option, and return exit code 49.
      shell_output("curl -s --connect-timeout 1 --telnet-option nothing 'telnet://127.0.0.1:#{port}'", 49)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end