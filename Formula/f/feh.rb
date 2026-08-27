class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.12.3.tar.bz2"
  sha256 "2236c21c2a02e1cc291c0d8827414433fcd26c260a60fb385a819e3af600cc75"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e5e1625123879677099a6f2d26222550f1ab17fc1447d383843424cb7d17a485"
    sha256 arm64_sequoia: "34e305bd1f83082aa4667772542f0616ab1c408278677372ee7956792d822b8e"
    sha256 arm64_sonoma:  "8f436e990bd4f7a6d6feed917d2e0e7d053a51ba52ec8df7c61939beae0c43eb"
    sha256 sonoma:        "564cfdb4bbdf46e6f6de52b186b2fdde86f197d872fca9d0e75119a400140114"
    sha256 arm64_linux:   "d16da77ddf94c817bdfdf322261b66c06203091d33689cc501f2862bcfe2058d"
    sha256 x86_64_linux:  "4ca6ebfc383038426fd3e7eed73793d2db49182b9bcdedc28c6e58de168b4797"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end