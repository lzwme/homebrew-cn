class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.xvzc.dev"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/releases/download/v1.2.0/spoofdpi-1.2.0.tar.gz"
  sha256 "1b7f4befa32dcefeb501ad2b87b4d9d2e8929137c1d552898d1535a18c59cc68"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93dab86b2cb9d31921e1e540aa1ba98096c36a53a5ccbb797281a5dfca4fa51d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0451326ae4a8f2a8e4a7fc7c557c3807b7321a3fea54e3523aba2e0f726d264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d33bd8cfded02782fd6ed8386fcdb8c5368cb67dd4aa9803a8acfad5896afbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8922157ccaa25c45f5ea0ebb3dd86523e549eb68ad8d3c90c5c5a2d80b449d48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c0cb542ef7be13c05e325c49043b11fcd40174f3e5b1ef8074d82684c01f7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b981f23d81b0fcb2b4508c2210650e92f3cb0a4293cdfc154a133ff561dc1031"
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
    pid = spawn bin/"spoofdpi", "--listen-addr", "127.0.0.1:#{port}"
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