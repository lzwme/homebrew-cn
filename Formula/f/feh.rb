class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.11.4.tar.bz2"
  sha256 "0f689c8e48b1ca662e0b44af61c020b1f26135aa898dc4ff5928e2f630917cb6"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ed136a967a5d08e8bead729065b3f10d04bbe02ede5b5e11a053516330c2f039"
    sha256 arm64_sequoia: "65822c97678d0a141c09ca19852d7a6cedbefaaba064d2e4c9cce8adf2110d0f"
    sha256 arm64_sonoma:  "6a54dca81dabf5846eaaf9f1f4d6ae0c7f90cd012aebca0595d7e00613cd7999"
    sha256 sonoma:        "e04586f092a3b6285b92253909ceb2fea0477706449c6803c77380a9d18fd417"
    sha256 arm64_linux:   "1a261a8e42b08b33dd9d89f68ed5473ea5c2fb29463aaea635a0317e1005fbf9"
    sha256 x86_64_linux:  "ae71827e2402f521fe6655b2a2e5f2c3609a1f8db589f62c6a45aeacff9299e6"
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