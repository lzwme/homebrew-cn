class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https:github.comxvzcSpoofDPI"
  url "https:github.comxvzcSpoofDPIarchiverefstagsv0.11.1.tar.gz"
  sha256 "ebeb8c23b5c4c9b71023d893bbd29ff3211246236144fe3f6032ac31437d79a1"
  license "Apache-2.0"
  head "https:github.comxvzcSpoofDPI.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "762180daee81677a556b92cc7e94021194d764602fe6ffba853055c0c5ff1257"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "762180daee81677a556b92cc7e94021194d764602fe6ffba853055c0c5ff1257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "762180daee81677a556b92cc7e94021194d764602fe6ffba853055c0c5ff1257"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e5fd98f245afb90d314524e54935c14e3d6af174182bdc61db4b9ff053e7cec"
    sha256 cellar: :any_skip_relocation, ventura:        "3e5fd98f245afb90d314524e54935c14e3d6af174182bdc61db4b9ff053e7cec"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5fd98f245afb90d314524e54935c14e3d6af174182bdc61db4b9ff053e7cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfad16d6e1fc587981508e5652d0b19a3658a3a5f0e68a61928d795cd5d8a7f"
  end

  depends_on "go" => :build
  uses_from_macos "curl" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdspoofdpi"
  end

  service do
    run opt_bin"spoofdpi"
    keep_alive successful_exit: false
    log_path var"logspoofdpioutput.log"
    error_log_path var"logspoofdpierror.log"
  end

  test do
    port = free_port

    pid = fork do
      system bin"spoofdpi", "-system-proxy=false", "-port", port
    end
    sleep 3

    begin
      # "nothing" is an invalid option, but curl will process it
      # only after it succeeds at establishing a connection,
      # then it will close it, due to the option, and return exit code 49.
      shell_output("curl -s --connect-timeout 1 --telnet-option nothing 'telnet:127.0.0.1:#{port}' > devnull", 49)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end