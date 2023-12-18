class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.1.5.tar.gz"
  sha256 "cfaf32fe58f68b7532f33b2a60e9507939ee54e32164db051357e059c553afec"
  license "MIT"
  head "https:github.comsxyaziyazi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b50744b72dcb5c074d7bdda8b19724e48ee656a810955d7f4318791d6ae300e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5be8049f6a9422adcccdf8b4c91d8340a569e94693bb95668a1f8e7436b5714b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3676e95614db729138473147498ed5abde5558e06b8dffa2cb7cc631cfcb66b"
    sha256 cellar: :any_skip_relocation, sonoma:         "68c0028ac63869139707253d19da55f573c263c4f91c448fd21c67c67b5d02d6"
    sha256 cellar: :any_skip_relocation, ventura:        "762ce4a801525ed8ef8f0cf22ac319e556db0b2ce9ac54d7446ce3240d2ff880"
    sha256 cellar: :any_skip_relocation, monterey:       "ce424d94681c839c467b0e5a98a8cafc06d11b2e522df31e15708cd086b318a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425962eb6f2d7d52c2272931726d19af6461342878f37bb4ff114817ba061c97"
  end

  depends_on "rust" => :build

  def install
    path = build.head? ? "yazi-fm" : "app"
    system "cargo", "install", *std_cargo_args(path: path)
  end

  test do
    require "pty"

    PTY.spawn(bin"yazi") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "quit"
      begin
        r.read
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_equal "yazi #{version}", shell_output("#{bin}yazi --version").strip
  end
end