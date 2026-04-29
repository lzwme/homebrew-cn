class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https://github.com/stripe/stripe-mock"
  url "https://ghfast.top/https://github.com/stripe/stripe-mock/archive/refs/tags/v0.198.0.tar.gz"
  sha256 "35497577c741d24f6b48cde2e22c0591c00571a5e588d4d9f6d8fe0db3e2f10d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5334817286b3318c9b236509aa9c43d45fd2bc425592f9214cdd64e84ba06dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5334817286b3318c9b236509aa9c43d45fd2bc425592f9214cdd64e84ba06dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5334817286b3318c9b236509aa9c43d45fd2bc425592f9214cdd64e84ba06dc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b52604c79ab2c2513989e1f1e5ccaf47664d6fbc40ce961fc34725c4717edc08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec3a9368462b8ade8fcbcf1237d6a71aef1296daa7ec6242c0f9dfb444f246f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0dbecb34b96deaff161864658f9253a5dd18ad8fc43231aa360661606afd2f"
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