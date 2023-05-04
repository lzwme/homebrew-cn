class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://ghproxy.com/https://github.com/hashicorp/nomad/archive/v1.5.4.tar.gz"
  sha256 "9773ec61998a88b89652f32eb15f5b8da8c0d2f572d75d124d62b89f854fac0b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3472055120e588aadb3f2ecbb917f0a2c2c6f0321bb79cbdab823d99942cc8b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47269986b55fa829327c749e47675c010ff93ae34d5528b960172c722a1d073c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3df9b33a3db0a116b7812c5d78d9d8bb8955ccca9d1dbb76a84f0b65d2aa0c0f"
    sha256 cellar: :any_skip_relocation, ventura:        "e97c76f591febcb56e8000f647e5536ec7c4477d2a40047ef33df2a4a460815c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae12ccd642863facb7f35e23e9a686260f7e9ae6eea3566c611ed82cc7d9843f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b8ecfbd0c8f4291e771ae38ed88dc896375e29e3ad9b11dcd7bc9aa1c4ef1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9884de46123828e99978a1be04083ca79ad24b7c325e59f63f317affdeb0777"
  end

  depends_on "go" => :build

  # Fix build on Big Sur. Remove when release includes this commit.
  patch do
    url "https://github.com/hashicorp/nomad/commit/780fcf9043f271caa249c8aceba69338db52dfbf.patch?full_index=1"
    sha256 "67222324f824e18f7a7e4cf83a22d8b759e37e4053dd2c8c2a90772dff5f9ccc"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "ui"
  end

  service do
    run [opt_bin/"nomad", "agent", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/nomad.log"
    error_log_path var/"log/nomad.log"
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end