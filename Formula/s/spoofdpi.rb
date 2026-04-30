class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.xvzc.dev"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/releases/download/v1.4.0/spoofdpi-1.4.0.tar.gz"
  sha256 "44f3792a0b37bedb2c95f4e34e67cb561272e1378a616da98175241a683a5e57"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddf9be7b68f14b0b6d6bde449c033c1bd535fbf9d28dcca3ca464621a3155038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f13cbd06422fdd7e21eceb36c882d077b28d33528681d6c28ec6e51acf68e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdbb1944773d972b5780d5a510bfb71c3d78e732db00d713781d8c9a8206787e"
    sha256 cellar: :any_skip_relocation, sonoma:        "978f5fd491912c3004ac40638f8e1922386ef784c438e3088a024e77c1dc72d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95508b50bad57b41e6fbf34660f4ea1e4aeb544f720c4ca7ea841fc29d529d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "705cfc2c65ad3904b18b1798b1ce42a8d1548c508b93ef0a568aa69636055e55"
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