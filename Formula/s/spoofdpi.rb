class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://spoofdpi.xvzc.dev"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/releases/download/v1.3.0/spoofdpi-1.3.0.tar.gz"
  sha256 "3483303ba31311c3245f7b5c767a6b4d8c294a633c15b15d3547a4728d342b1a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcf14e3fca87b931ac66ffb8426f17eafe8567ea64ddcf200d9ba9bba8fa187f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96aaa3ee31dbe4b97918777835f03a378202d50fb92a7c1dff2fd9c816580f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ef5c3bb71d5b4473c37bc5952804d921aee713a90c01b8b7831be5f8e7efeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "23aef349182182e8a2a20bce6237e897796f926caa805af8234964bb8270e184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdced136d2cfede0472beee2935b82692a018ec837958c9232abdd14735d916f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb362bea7f9b7f13448dd7cd360aed7a6ea5030edef878e9120f0c674189047"
  end

  # One of dependency `gvisor.dev/gvisor` needs to be updated, but still go v1.26 is not supported well.
  # Issue ref: https://github.com/xvzc/SpoofDPI/issues/365
  depends_on "go@1.25" => :build

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