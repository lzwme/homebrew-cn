class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https:github.comYS-Lcsvlens"
  url "https:github.comYS-Lcsvlensarchiverefstagsv0.5.1.tar.gz"
  sha256 "008a4e6ae7900c7c7642ca8ad11057967155173af267cbb9c6236e774adc18e3"
  license "MIT"
  head "https:github.comYS-Lcsvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f1e2cb7099395a9b9c27d8726dbfa4364d4129d1eab1a246bbe1e265a72b128"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcddb3ed6ec79365223497881a0b15a4360926b591b14fec03dc8000029af2e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7951f625fca152d9448fdd2440809f55461aab002063f1f28d4fdad504a3c990"
    sha256 cellar: :any_skip_relocation, sonoma:         "94a1f6bb07ee21393920b6e0ee5cd3631488063b90fc071fb081285a386082a6"
    sha256 cellar: :any_skip_relocation, ventura:        "76d83ab409174f02f90dda013d95c759b6b8652eb05b974a4ffa2e3b466dc608"
    sha256 cellar: :any_skip_relocation, monterey:       "d69900eea876983767d14f0685c3d5becba639ff561995b20415976ece19deec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a0ee4631418e67a460dd94ad92a719c920a0a64d430a809e4f9eff114787e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "ioconsole"
    (testpath"test.csv").write("A,B,C\n100,42,300")
    PTY.spawn(bin"csvlens", "#{testpath}test.csv", "--echo-column", "B") do |r, w, _pid|
      r.winsize = [10, 10]
      sleep 1
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
  end
end