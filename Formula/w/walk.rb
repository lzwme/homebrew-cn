class Walk < Formula
  desc "Terminal navigator"
  homepage "https:github.comantonmedvwalk"
  url "https:github.comantonmedvwalkarchiverefstagsv1.12.0.tar.gz"
  sha256 "81db744bbd36d55bde26f7fafce8a067baa6d1d81ae59aa090f48c93023a2bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96aaac9cca43e22e99167c63d64293629f3f43c05ce16f424f2efcea5196028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96aaac9cca43e22e99167c63d64293629f3f43c05ce16f424f2efcea5196028"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a96aaac9cca43e22e99167c63d64293629f3f43c05ce16f424f2efcea5196028"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10992a2e962121750542c6a908e008787d3fed5e3e8da171b2d59fc3fd80f43"
    sha256 cellar: :any_skip_relocation, ventura:       "f10992a2e962121750542c6a908e008787d3fed5e3e8da171b2d59fc3fd80f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35b3db13dc18c195d01f40c8d01f1fbed2ac542300dec80e4e121d956ba5a8f"
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