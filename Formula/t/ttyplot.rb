class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https:github.comtenox7ttyplot"
  url "https:github.comtenox7ttyplotarchiverefstags1.5.2.tar.gz"
  sha256 "a0279e55c1996133645437ccb02574c82d62f0baa9744065779b5667c1f1cb8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a09e6aa459020ed535829c4dec9eaff19eadf5b3ac47aff102f2bae7da9be39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7361f5439db3aa66a038e8aa042477d19b848ce8532d855b3b609ce4b3b9144e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a066c2fa7a1fa132e3c6ca706a4f4adc53db64c0c9b8a4c034279758e23a2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a17c3d00ddcc562aee513ad04d57ca2bdeed4c756ba3283433d745aa9c2c42c3"
    sha256 cellar: :any_skip_relocation, ventura:        "a814dab755942c576a4ad8aef019a163881f37a512aee2dc6873d0a0418f4cac"
    sha256 cellar: :any_skip_relocation, monterey:       "cd9b66553fd7b2c3a23bd36c5e810cbc3b102e5d1b15348a0121030eb9eb3326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e56d05e544689dad064207f4aeff14e0199bfc242a62b8c3a9b39962d67fd8"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}ttyplot -h")
  end
end