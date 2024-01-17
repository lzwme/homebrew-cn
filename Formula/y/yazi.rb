class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.2.1.tar.gz"
  sha256 "c821979b1ae08e7bcf2936635bfcd25715e74f240a6c4a2dbeb4ba9ce0d8be8b"
  license "MIT"
  head "https:github.comsxyaziyazi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff93144810bb1d13ddfbbf3c5ad2776ea31670e1800ff59b92f2e8e08364f064"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81e394de104170fc5f009c5c2d84f4a629ed8496be939ac748aa8a0c84c9b43f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9950a55995ec80b13e3ed9cd485bdb4170a8c92ee355936e9a047ef5cbbcbee"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c757c16cbc0e50b8e1f2043762acbbf724f774e7348f69eaee9f44297d4a46a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f3f602d29a3f48b09685307ef074905bf5292af885ba15ff21fc3b81a61b8b0"
    sha256 cellar: :any_skip_relocation, monterey:       "3d992f73df4543532788dced545972534eeac7d756f910c321967087f9a546e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed07ec28ff267c6cef6444478f42efd18578962749a74ca80e72979022e6ccff"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
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

    assert_match "yazi #{version}", shell_output("#{bin}yazi --version").strip
  end
end