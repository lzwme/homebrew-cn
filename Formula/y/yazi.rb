class Yazi < Formula
  desc "️Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://ghproxy.com/https://github.com/sxyazi/yazi/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "e6738a12896ff0ab081a306e6334702a93dcb1039e4c596eb6ee723a6bc037cc"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61fafd26a35bc485ea6271f3e0809b58e80a9898aecc7b731347332455cf30b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8b00b4b6c5f195a72a5de52d03586c067ec6b0da3e3c9ae87cb23489d86d1f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "919bf6a02646308126eec570ca27fc5a16135531566ccef3dc6760eac4264787"
    sha256 cellar: :any_skip_relocation, ventura:        "ecaed183982899737cfe8e4bc2f76e579c519f55cc47eba5848138c5785634d7"
    sha256 cellar: :any_skip_relocation, monterey:       "bce42f056e28dc664d532b71094286ad4f39c6d1463abe53024b58d0f0df1782"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fac6a20be20ac3c03a7824bf9c1bf1347c00d1b8d0e21a248185dab743ff406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f55b93826b19f6157b82de039bd7b4a6521dffb6785f519c3815bf2eb6baac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "app")
  end

  test do
    require "pty"

    PTY.spawn(bin/"yazi") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "quit"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_equal "yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end