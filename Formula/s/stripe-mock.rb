class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https:github.comstripestripe-mock"
  url "https:github.comstripestripe-mockarchiverefstagsv0.192.0.tar.gz"
  sha256 "9b38137b879d3c3b580ce6697dfe4de074a0178a7c96ea55502f26417b1e37e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec7f7d65d240f5f0a4f15e2434ade968cf6aa97b7c72a263923f5655c93e1ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec7f7d65d240f5f0a4f15e2434ade968cf6aa97b7c72a263923f5655c93e1ccf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec7f7d65d240f5f0a4f15e2434ade968cf6aa97b7c72a263923f5655c93e1ccf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cce95a8ff69747e41e9b0110afc740776498d734d9491ba4197031279ca4fcd"
    sha256 cellar: :any_skip_relocation, ventura:       "0cce95a8ff69747e41e9b0110afc740776498d734d9491ba4197031279ca4fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd145e4dc0930347a066c450bd811626e7e10bf699314531208d9a2fe38faf1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  service do
    run [opt_bin"stripe-mock", "-http-port", "12111", "-https-port", "12112"]
    keep_alive successful_exit: false
    working_dir var
    log_path var"logstripe-mock.log"
    error_log_path var"logstripe-mock.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stripe-mock version")

    sock = testpath"stripe-mock.sock"
    pid = spawn(bin"stripe-mock", "-http-unix", sock)

    sleep 5
    assert_path_exists sock
    assert_predicate sock, :socket?
  ensure
    Process.kill "TERM", pid
  end
end