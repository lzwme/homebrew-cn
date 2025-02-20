class Walk < Formula
  desc "Terminal navigator"
  homepage "https:github.comantonmedvwalk"
  url "https:github.comantonmedvwalkarchiverefstagsv1.13.0.tar.gz"
  sha256 "9f62377438908757fcb2210bd08bf346391858f21d0ef664d7998abf635880cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce3ab82e4e2280c930d6f3c532440a20749e42175316a90fb64d7f00cea7d1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cce3ab82e4e2280c930d6f3c532440a20749e42175316a90fb64d7f00cea7d1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cce3ab82e4e2280c930d6f3c532440a20749e42175316a90fb64d7f00cea7d1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9719de03b75d0b1697d97ca68da9481bc29191c5cb3d89e5d899f7ff8c61ef1b"
    sha256 cellar: :any_skip_relocation, ventura:       "9719de03b75d0b1697d97ca68da9481bc29191c5cb3d89e5d899f7ff8c61ef1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa31d4ff035f46edf2aa77d9b6165e4edb93278f268b059325bed36d3b8e42e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
  end
end