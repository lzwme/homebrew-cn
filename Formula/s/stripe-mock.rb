class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://ghfast.top/https://github.com/stripe/stripe-mock/archive/refs/tags/v0.204.0.tar.gz"
  sha256 "367b9178babebf70448ee4c92ac0fa5bc32c3c4dda973da3cbc34e8eb20c9583"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c65f67b38421103b5f450014cccaf6aecc88a122b5d6e19e204d4a4b01e8446"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c65f67b38421103b5f450014cccaf6aecc88a122b5d6e19e204d4a4b01e8446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c65f67b38421103b5f450014cccaf6aecc88a122b5d6e19e204d4a4b01e8446"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33f095b8e72ead56ecf9cebf6ba4c511a8fadf625d1093a7d80f57569e2ef955"
    sha256 cellar: :any,                 x86_64_linux:      "53c9c8ea1bfe7f915880233390362a8ff65d57af75ae57b6c1f7132a011495f4"
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