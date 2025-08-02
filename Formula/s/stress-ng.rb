class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://ghfast.top/https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.19.03.tar.gz"
  sha256 "a5ddd9914a4aa0c4708035a475772cb7a6989f28829e608ad790d64849610ae6"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8757dd08f576d065cbdc239203baf258517d2b6b0fe031b339d2bb48fcfdb7d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc012e2547d18888f9b623f29bafd61ef700568f771f4a4e614064bb12c19438"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f903546743cbf5a0d1312e92e5cc94ee2ec575a910d041f2ac21c98958e439b"
    sha256 cellar: :any_skip_relocation, sonoma:        "144ce41218709cf20db1b5c97ded33ed4bddd5fc470ca53187795b4921df60b3"
    sha256 cellar: :any_skip_relocation, ventura:       "08272b1a862a6667f633a72383f6fbee5d6cf2c358033c7d8c14e68c52e57e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "246900f2749e9dfcc18a991fd8c0e55925925766266a067b4ce43ec6fdff302f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84370b2aa7e2010cb25ffd5a22d7c817a2a5fd269444b44d03acdbd7d1ecb425"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end