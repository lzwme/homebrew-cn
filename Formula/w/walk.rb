class Walk < Formula
  desc "Terminal navigator"
  homepage "https:github.comantonmedvwalk"
  url "https:github.comantonmedvwalkarchiverefstagsv1.11.0.tar.gz"
  sha256 "8df1a97a4f123a81e20f5344ed1c0f6f390776c5934cb9c3f38ff82f69bd7898"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a405889469fcbd8cce9c0d13d9f31323f0ff559325564d17797f1367a9ac7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a405889469fcbd8cce9c0d13d9f31323f0ff559325564d17797f1367a9ac7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a405889469fcbd8cce9c0d13d9f31323f0ff559325564d17797f1367a9ac7bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "547da225cb6b32881127d6005eb154acb0028c2cb73ca7297ec40a7cb4604eba"
    sha256 cellar: :any_skip_relocation, ventura:       "547da225cb6b32881127d6005eb154acb0028c2cb73ca7297ec40a7cb4604eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f696756182d25b35a4e7e97d5a375965ba9f3824957fd23059fe023d27e431"
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