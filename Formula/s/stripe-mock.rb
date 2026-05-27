class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://ghfast.top/https://github.com/stripe/stripe-mock/archive/refs/tags/v0.200.0.tar.gz"
  sha256 "5b3cda961b0b8d16f9fa6ba7b75318977abb06f1aa39362eba259dab01e9c632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b563625eb840ce1eb2b4af21cc5fa5a8816e40e08c24fd7538925ff76dd62fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b563625eb840ce1eb2b4af21cc5fa5a8816e40e08c24fd7538925ff76dd62fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b563625eb840ce1eb2b4af21cc5fa5a8816e40e08c24fd7538925ff76dd62fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e460a3c24194b66428f68d53cd7c3c7e87e9394873179814a2d48108ed3c3029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "208b03a0a30c3aa4c0484621171dfbe9da0ed31485a045ef500c1cb8ae56ac2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36444f97d3e8bc3f17058d2a1eac0b42bf46193971f509148f8d2e4dc5bfa9e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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