class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https:github.comLifailonlazyjournal"
  url "https:github.comLifailonlazyjournalarchiverefstags0.7.6.tar.gz"
  sha256 "9a997cdf451c2a5cba4c7ae26656219b8c28146161246e6238e27a723ab99a05"
  license "MIT"
  head "https:github.comLifailonlazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe0c4f9a17f40e6d03e7be0d0f409654a6ef64c5c25a67e79250876721121526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0c4f9a17f40e6d03e7be0d0f409654a6ef64c5c25a67e79250876721121526"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe0c4f9a17f40e6d03e7be0d0f409654a6ef64c5c25a67e79250876721121526"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7ace6311d2feba22bb60969ff2c4887474d58636f18c0870641b89178288bc5"
    sha256 cellar: :any_skip_relocation, ventura:       "d7ace6311d2feba22bb60969ff2c4887474d58636f18c0870641b89178288bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d59d4685901baccf4b52ca5eb49c79f605ab540f035f6660fd4efe864c4027"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.buildSource=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}lazyjournal --version")

    require "pty"
    PTY.spawn bin"lazyjournal" do |_r, _w, pid|
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end