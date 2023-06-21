class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.29.4.tar.gz"
  sha256 "543b87a50b1681131d4ac8ff920508d546549523f9b44e0c728d1e65291a14b1"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2df33fe588cc769b529f2167f78598a64837fc57b6d7bee82042b0c3028c72a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cc1b279778badba64e6a1732ce3e448da2665a7160f81bb38d9f4018e6b3bf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68a858e2acc5bc6abcd3284a298360bb94d7482f6514faabd8382de27f618faa"
    sha256 cellar: :any_skip_relocation, ventura:        "08b553afa7f77a272aa90d810cb689a7512ca42fb3383b446cd1eb4890c4fbdd"
    sha256 cellar: :any_skip_relocation, monterey:       "aaab3ad6032bc0d31aeaadb625cb917bf6e05c90049fe70ddc63b746d9cdcd8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3ae0ba88089174b0e2b6167e8a103ff19f188c4fa1296fb107b8ae4610760da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9672d8ca2c71b17cacfe403d7c77bd3cb1ec526b1cd70f3c891f79306b54d824"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end