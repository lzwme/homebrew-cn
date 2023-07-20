class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://ghproxy.com/https://github.com/hashicorp/nomad/archive/v1.6.0.tar.gz"
  sha256 "e1a5180e348564d2f7ccdada31dc089e371562b8fc2eebdd7541e01d1be4a1a8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4962867556169a9366f430229181ef4fa7505307d667331ea847a90dee31fea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcdaf4ee3c9115e03d86793e3e9515691dc763a1a6c968fbc7d2c773eb790c2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38c0a859d46d6eee7b90c8bd5bab765884b1c91d442b8b5dad9271dcdb1deb38"
    sha256 cellar: :any_skip_relocation, ventura:        "b481dbd86cf01d090357aafadf71b3c3e0b0ea2d9dacef5399a169352d961dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "9915b5f097014b3f9228b79cf8c038029fdc2b38c0b18a3c973448bd3014580a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2335c264cf999a0e746fa2dfd3326acbbf7f7acf5f6c51419e5abc01418d6efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89d40be347d70f427d6553dea0633f1c32a83b50bc374c0adb8e0bb6d65c265a"
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