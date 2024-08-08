class StripeMock < Formula
  desc "Mock HTTP server that responds like the real Stripe API"
  homepage "https:github.comstripestripe-mock"
  url "https:github.comstripestripe-mockarchiverefstagsv0.187.0.tar.gz"
  sha256 "c50b73607aef202686b2a412aa5be5c99b7d3c0b7628aa89c185e5c4a3215a32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "939ba66a181bceeaedab98b0d0555126fbb91af4c9e6a7d0ce970a9a3be40a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad277b5476157d21b24be7ad636661ffd8c7daa673efc4e91671769ebfe1feb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d2197a619871b35d354733a60555579795d858476b2878b21571eb9223bf252"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba9890f72fa59bbe08f08573fc595b410bd73a80e2a245d6326db67d5e06823e"
    sha256 cellar: :any_skip_relocation, ventura:        "445dc3811b90c3e0b7c8900960f724ca95302cbf765b8b8d05bf55a5ad130a9d"
    sha256 cellar: :any_skip_relocation, monterey:       "cac8c5979bcc0bfb81757d675deb73f3f83cf3fddecfc65a05b7e1650b48eb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "996e723b3d92839bea22353f9d0d1e2362fbd26a15d8b70ab1fb19dd1a9e8a44"
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