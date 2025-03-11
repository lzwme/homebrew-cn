class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https:htop.dev"
  url "https:github.comhtop-devhtoparchiverefstags3.4.0.tar.gz"
  sha256 "7a45cd93b393eaa5804a7e490d58d0940b1c74bb24ecff2ae7b5c49e7a3c1198"
  license "GPL-2.0-or-later"
  head "https:github.comhtop-devhtop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "677c0a92041b0e6ac154165ffbcfd67a6213e54a7f76c02c77c7f857f38f47ae"
    sha256 cellar: :any,                 arm64_sonoma:  "22187a55adee8dd80b5ad15fd746d5f6284a88d5c4e450e38c463e0c957f8811"
    sha256 cellar: :any,                 arm64_ventura: "890cb59f4dade937992d35ac71c571c429da4ba3f858174647dae00d2b30f044"
    sha256 cellar: :any,                 sonoma:        "49b47ec58f7bdf9fa2fe65b3cbadf6f80290745ddd8b6b7d9a71df89da9ebf65"
    sha256 cellar: :any,                 ventura:       "4a9209d7c67437994a49dcbf4560148283152b655ffef51111e3160700fff430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66dbb45ffe4c0a28e0bef60a2819db27d2f61b03ad8417b3d6a95fc19eb5243d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ncurses" # enables mouse scroll

  on_linux do
    depends_on "lm-sensors"
  end

  def install
    system ".autogen.sh"
    args = ["--prefix=#{prefix}"]
    args << "--enable-sensors" if OS.linux?
    system ".configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output(bin"htop", "q", 0)
  end
end