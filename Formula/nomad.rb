class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://ghproxy.com/https://github.com/hashicorp/nomad/archive/v1.5.0.tar.gz"
  sha256 "7b89b79e81dba5ae57a88009378c00cd1cc4f457e02e3a6e33976eab09cdd88d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08b9662d2e308635bff014663ebc70982290556d7c1daf1f9771561606e50c4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0560682dbe76664fcbb4805b3935a73475189aa44d366994467e1780c12654ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4baa6b8a92bca3a6870738f8ece1a9265a1d5413df8d0a25e32f24e5fa2d471a"
    sha256 cellar: :any_skip_relocation, ventura:        "6c606afe34d78a054ff0fd8d8b15da535b66bc5b92195d551c30e2daf999190e"
    sha256 cellar: :any_skip_relocation, monterey:       "12e2ac620b05079242ec7e6ebe9f6dcd066d34d43867db341bd4833d70db88f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0da1de9da8166d58275381d7e0e1a56866e67cdf924e178e740db29801cf5f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c6a5154a61ae1e99801709bcedd9f0ff08320b558708b21e42f46c1b93dd89a"
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