class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/releases/download/v1.4.1/spoofdpi-1.4.1.tar.gz"
  sha256 "e7144d7c9ae4dd2a4ba33c26ee19f333aff77b2c4a15191d65e570557ddd9c82"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aedfeb1d34771ec6dc6e29cd8a36499b2cbe3dd123fbb93c567c7bc33ecff2d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4763bdccab298b53ffc2fe6e18cfb9229f1ef2d1aa060c055ed0fecd6e4ba9ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf93ddb3ae44beb0416a9199c885e43b2b80ee19d8e040911376a93c38e9c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2882a36a51980c08050773f9b12cae30fbe1c4649d93031b805617205a28250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d72c7b7ea5e33bfe8eee730332607a870f3c5ecbe7209c42cc5c0b050568cc5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2104b752d6b0de9ab50d53e5b60203f451d268f0007852e36534de9184cb86d3"
  end

  depends_on "go" => :build

  def install
    # Disable CGO for Linux builds
    ENV["CGO_ENABLED"] = OS.linux? ? "0" : "1"

    # Prepare linker flags to inject version information
    ldflags = %W[
      -s -w
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