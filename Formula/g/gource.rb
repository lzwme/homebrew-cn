class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https:github.comacaudwellGource"
  url "https:github.comacaudwellGourcereleasesdownloadgource-0.55gource-0.55.tar.gz"
  sha256 "c8239212d28b07508d9e477619976802681628fc25eb3e04f6671177013c0142"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "3596c21ecd8e3c2b225d9ff98defa38a5496d52c8e9f34464a2e414f8c9ec8f6"
    sha256 arm64_ventura:  "7356eb34bd94d8a6aefedd18cf85d09b3fd19d7ab09363e9d20c5e45eab71a81"
    sha256 arm64_monterey: "7a59b2bf59553a8a20a83cf6a2c4dbd89438fee6d3959e06c6e27bbd84f84a3f"
    sha256 sonoma:         "b1bfbbb3b3e6c635cea3dacf66167842135a9d6648c0eafa40d899fa7e1166cf"
    sha256 ventura:        "c2c1c4c00db4ebb316b6b7797440f7851b08c14bbf259701c4a71e57bbcbfaaa"
    sha256 monterey:       "ecf466f251a966b38fb9d7ddf4a7ebb234b0396205d380b39bc83ecb063400ad"
    sha256 x86_64_linux:   "2008fd1997753832a8377facbaabcd081d96e1fa5d1128f23624d11f26e5ca5a"
  end

  head do
    url "https:github.comacaudwellGource.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    ENV.cxx11

    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system ".configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin"gource", "--help"
  end
end