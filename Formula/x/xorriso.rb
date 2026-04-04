class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftpmirror.gnu.org/gnu/xorriso/xorriso-1.5.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.8.tar.gz"
  sha256 "319e3675cd7d986bf71d36596ca7b03dac172a758462bedcbbd298a7f86f36cc"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?xorriso[._-]v?(\d+(?:\.\d+)+(?:\.pl\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629036e47e08270cae6d7f8fb3458362c13fa65fcf0eff184f9b7e16fa88d924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0870121ca2a235cf92df9b033c5185397ed34627385c88d067be0a5abd5a030d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15a3ec01f7900d30dafcc7e47027dfb9f9eca88144760e7a62ce46d71e62e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef488f42015efaeeecca1d86e66d25f2bb34e6051be0e10ebdcc8ac662088ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec46fc839997683dd3d971c7e680af63a5e9d4872f29e38fc5bc332976fc905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263686a59bb925025a40ca2a0bfaf1b1e37b29a43ca68e056b33c4385196d30d"
  end

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match "List of xorriso extra features", shell_output("#{bin}/xorriso -list_extras")
    assert_match version.to_s, shell_output("#{bin}/xorriso -version")
  end
end