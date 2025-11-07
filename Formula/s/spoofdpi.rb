class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://github.com/xvzc/SpoofDPI"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "d1f38e25bbd9c9481e8d45c4734e3b13249fa2e3898f1203c8049f08bd007ab1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235be81362797820291b8b9b08a4fe178cc66f1c2181fa94d91eda1b6ebffa97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db06ec5407ddeb6969a64ed311ef12d343e8a1e1927a14f378145e39d96c18c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "034aabb2f5304530479574461fc2520f47a355b33230fc5e910147945442f153"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff9aaf5f8c7fcdd86f22e2f9ed42e0e7d385ef97268923d7bffb29930f079527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f16aa3e56a8f835579601e6fcdf31423da409a7042267a398421116b4f8e19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5975a9681fa939febb7850eb8f5478daa6a720d0291449ca9d5a796d23f4506"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/spoofdpi"
  end

  service do
    run opt_bin/"spoofdpi"
    keep_alive successful_exit: false
    log_path var/"log/spoofdpi/output.log"
    error_log_path var/"log/spoofdpi/error.log"
  end

  test do
    port = free_port
    pid = spawn bin/"spoofdpi", "-system-proxy=false", "-listen-port", port.to_s
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