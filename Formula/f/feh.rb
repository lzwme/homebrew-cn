class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.12.4.tar.bz2"
  sha256 "97e89bb2cf5ada41e8c8e916ea4d7d64c51faaae4847f00fcc088fa06e1b5ca1"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "818433b8b9a12134327210dae9c837f8902fa80d851f2cd6ce9b9ae6dd198ff6"
    sha256 arm64_sequoia: "a38a0764412710eca484b5e73984f87317cb8d44a70b5c5435bcf6cf56e57d3a"
    sha256 arm64_sonoma:  "02cb2ae509a5a57df4ae84150cd37ce9674ede899bffbe66ecdbc95abbbb561a"
    sha256 arm64_linux:   "995c96e08266ef82a652fdb64f43e406407052627fa1f22b20e076c43fab6fd1"
    sha256 x86_64_linux:  "eb3c9a2e374cb084735f20eb965f3def96e9360f32da6fa3ce5b983d19d38bf3"
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