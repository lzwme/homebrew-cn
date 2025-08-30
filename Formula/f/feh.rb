class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.11.1.tar.bz2"
  sha256 "43d8e6742ec273ef3084bde82c5ead5a074348d9bfce28f1b0f8504623ca9b74"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c5808008dd3b8fbbe80c2c173b90eaf97334ae64dee068198c193640300aa608"
    sha256 arm64_sonoma:  "efeab7a7b248742321ac42b569fc0b1272f7b45e6c7c0dee3457dc173877cd63"
    sha256 arm64_ventura: "a26c512e52ad7b4bdba7c4d2e17aaabbcfa1f046fb5c42612f8a305fc7ed9355"
    sha256 sonoma:        "490f597fd595243e8ceab1d9183be0daa947612771f409cc6a3434f58fbb2138"
    sha256 ventura:       "d482f7842a1dfde6f53cb156135d52efb0d283d5f54c003f74eab0a94e8c96fe"
    sha256 arm64_linux:   "80901bf6db70cc38d782f7cae01456dffa3cd62138f37529b6541dd935df1589"
    sha256 x86_64_linux:  "d7149aee5bcc4531be811932712e576793c943264c75d1284c3824e42fd4403e"
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