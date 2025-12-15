class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://gource.io/"
  url "https://ghfast.top/https://github.com/acaudwell/Gource/releases/download/gource-0.55/gource-0.55.tar.gz"
  sha256 "c8239212d28b07508d9e477619976802681628fc25eb3e04f6671177013c0142"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 arm64_tahoe:   "65c6b3a4d7ae1e2f905a73cc1f868322956177ff6d0672f4911fffe7156cf2e6"
    sha256 arm64_sequoia: "7bee142929711a8199e18662e9101b84e53d814c74de2b7955b7e801aaf5ee48"
    sha256 arm64_sonoma:  "7cb084a3f972345a7d793ffc795b32e4eb9885f20110af986315643f6afec401"
    sha256 sonoma:        "88d15ac29e1945bc5815b578c19bc1228700d02f2143f525570ed743e5d2d0a6"
    sha256 arm64_linux:   "80c0bd6c8f96c32598413e0ae0059cb37239804c7e0412274da79236cf75dedf"
    sha256 x86_64_linux:  "a2d2ef5e20fa488e26a5931dd60d23d9f427fc0cce4b240d843c064b0cd51dec"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Workaround for Boost 1.89.0 as upstream commit requires regenerating configure
    # https://github.com/acaudwell/Gource/commit/1b4e37d71506e6ad19f15190907852978507fc6a
    if build.stable?
      odie "Remove workaround for Boost 1.89.0" if version > "0.55"
      ENV["with_boost_system"] = "no"
    end

    ENV.cxx11
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gource", "--help"
  end
end