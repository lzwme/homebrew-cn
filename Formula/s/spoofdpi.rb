class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://github.com/xvzc/SpoofDPI"
  url "https://ghfast.top/https://github.com/xvzc/SpoofDPI/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "6b963e5c52e129f1bcac3b5adc59322715f5d31e593eb317e363c18c77f53a5b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5537d060d91ee7bc56404f202ce34b903ea24ecad005d90bbe9020224b972927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5537d060d91ee7bc56404f202ce34b903ea24ecad005d90bbe9020224b972927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5537d060d91ee7bc56404f202ce34b903ea24ecad005d90bbe9020224b972927"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab11ce8f3bb4f4e24cfb49d4c03e327721b0c975e85e6ae68dd318ada8c60f03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e06d30ce79749f99c60eb7fcb6068facf98a13f8ae948d1f707411ef22835d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a19ee7d6a2a6a7ede6269571afd4d2c8f3ca6005bd58d9137556a4550fce813f"
  end

  depends_on "go" => :build

  def install
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