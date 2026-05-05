class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.dev"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/releases/download/v1.5.0/spoofdpi-1.5.0.tar.gz"
  sha256 "f73f4107218c3ebabaac259cc31ee70b447e8b996bc970bc94c8e44106eaa5a1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "827ffec44963682f13070e65099571599d12edd04db0f8a07ec3a34af067cbda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa44a42eeb437ccc8767c536cb1aa9dbd78a2dfe4bdc343cca385237ff720c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae13e72ab63d9aebf8d28a755bb96104abcd71a08b30cad77e26883ea6e2254"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b8490341b707fae479360075af5ea0ba0393999c0612c6edb70f4ab3e8b514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "134b876ec8933635310001086f42bfab086043bcc3541df10ba0a5aff1f96046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f5ccf392684ee8b0f4302fcabba9a8e1cad24441baec96fe2161feecbe9cb3"
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