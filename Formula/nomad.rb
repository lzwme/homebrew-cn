class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://ghproxy.com/https://github.com/hashicorp/nomad/archive/v1.5.2.tar.gz"
  sha256 "a317456c335efef68a495bc5b68e78cab3abcd3bba4ae997b55b5cd698556999"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b6675b822b19f8425db9473e4406a0b292c37f13a17d82c328f6bc72b1c9cc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f168835eeb8a779668008c0fe2e4699bc17e31ea395c6cbc244a4223beab184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7085e4bd72604c144dbe8a8330240a90e6f35745c02c6e928f91181b3a8eabbb"
    sha256 cellar: :any_skip_relocation, ventura:        "85ebf188a6981f5c1d5da64ad3e91da6299f25cdaa32bbe8451bfd462ddf8580"
    sha256 cellar: :any_skip_relocation, monterey:       "d577f51a60d74767f3aa2813c749db225382c3cf3f7851b25d2b38f6fd18be8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd815198e54fcf8c26bc8007dcc39553ed676fa685047e36e96c9ef5b179c01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3f8028ec9a9de3bed54206e77f6f8eeafeb3e0ab8b4fd970cdbef284a3e73a5"
  end

  depends_on "go" => :build

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