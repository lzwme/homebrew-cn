class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v5.3.3000.tar.gz"
  sha256 "c929c858d156ed009986c05a392570ca00249807b49a51e83ddf6487c6423bab"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d76a5b5a0aff56fef57de5f103abec33baebc9fe40689ae72bd6ccfe1bea01a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8d7f454d036ce35af89af055a2c86063f2540f7e9ce25cf2ee3548788d9c619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e4079be060e31432fd54c221331605e99957f2c7f010f4844346f0fc36f2896"
    sha256 cellar: :any_skip_relocation, sonoma:         "98961f058ab5511b9b6649185873833b965297bc5c9e52b806ecc5b44d9ba342"
    sha256 cellar: :any_skip_relocation, ventura:        "41078ae1778685b74cdc3773393c9fe3337efdc9c6591d909799c676f32b892d"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e5026cd7f216b3d7c462c1f97a4f87622932ee8c5b8665d95b3799b6fe1a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3366283813f5014b47d6f6ef70c656b8cdb0c596f161ba951c77791b7bc731"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end