class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.2.0.tar.bz2"
  sha256 "7905a9516b5b2138d28ebcab978e7cae3558670d096f812c9688813752e3c119"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3aafb34ac21139cc3d79ecc5146570da326d6682bf85ddc6056015ae4bb61dc6"
    sha256 cellar: :any, arm64_monterey: "e97ea35d94f85460dafb4792ac4ebab14946be548f19f6f62828e1d99e9790a9"
    sha256 cellar: :any, arm64_big_sur:  "7235135b2f206fdd0c63f27bb6cd6899919c468b5062dbe70414c270687f0a21"
    sha256 cellar: :any, ventura:        "863ba1a7fbf31c2750ca998ee7c1bab2876bafcb0ed5e3415fbdc14388bf1bf8"
    sha256 cellar: :any, monterey:       "5f11e2c5a83dfb9517f65b8f9223135aa4a199febdd8d1640f95ee42fbc46e5d"
    sha256 cellar: :any, big_sur:        "dd1bf6b9066f9196a59b096ff3a08c81b819998912478746161f81c59467cae0"
    sha256               x86_64_linux:   "de85c3f8487f73ef449735b66c584f5ea3c1623badc5c694a6fad154aa502964"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "ladspa-sdk"
    depends_on "vamp-plugin-sdk"
  end

  fails_with gcc: "5"

  def install
    args = ["-Dresampler=libsamplerate"]
    args << "-Dfft=fftw" if OS.linux?
    mkdir "build" do
      system "meson", *std_meson_args, *args
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end