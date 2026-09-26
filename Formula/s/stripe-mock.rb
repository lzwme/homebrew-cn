class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://ghfast.top/https://github.com/stripe/stripe-mock/archive/refs/tags/v0.205.0.tar.gz"
  sha256 "80ff75ef0e238b454ba37502ca886f23b26b331dfabd67be2136d9ce9dd7f3c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9af2b492af30cf41b230e1974f74325d0269340f1e6e115d27978ce2c6cf7ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9af2b492af30cf41b230e1974f74325d0269340f1e6e115d27978ce2c6cf7ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9af2b492af30cf41b230e1974f74325d0269340f1e6e115d27978ce2c6cf7ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5f5d65aeb7506e0c51e93f0b097f6717047e0508ce96ee4b4833fb64344846a6"
    sha256 cellar: :any,                 x86_64_linux:      "ef42197c53fc4598b7b789fd421c6881dd544cd313a700fd7d11033d158afc64"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  service do
    run [opt_bin/"stripe-mock", "-http-port", "12111", "-https-port", "12112"]
    keep_alive successful_exit: false
    working_dir var
    log_path var/"log/stripe-mock.log"
    error_log_path var/"log/stripe-mock.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe-mock version")

    sock = testpath/"stripe-mock.sock"
    pid = spawn(bin/"stripe-mock", "-http-unix", sock)

    sleep 5
    assert_path_exists sock
    assert_predicate sock, :socket?
  ensure
    Process.kill "TERM", pid
  end
end