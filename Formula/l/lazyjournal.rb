class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https:github.comLifailonlazyjournal"
  url "https:github.comLifailonlazyjournalarchiverefstags0.7.5.tar.gz"
  sha256 "6405f53aba44ddf3e7e93b5ed5fc14f0132f6b84b4432e85d57c9ed32d847074"
  license "MIT"
  head "https:github.comLifailonlazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efafc02175b84177911c78ca8b0eaf699bbfebe8241c1ac94b53d42a609a4dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efafc02175b84177911c78ca8b0eaf699bbfebe8241c1ac94b53d42a609a4dde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efafc02175b84177911c78ca8b0eaf699bbfebe8241c1ac94b53d42a609a4dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e7efa410739df2ac5853766b2d0f5b77f63c62c2d33433c5829ca56ef10939"
    sha256 cellar: :any_skip_relocation, ventura:       "30e7efa410739df2ac5853766b2d0f5b77f63c62c2d33433c5829ca56ef10939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "077ad1afb376863d49348af5395026c550297266472f8a476f168c258e37c711"
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