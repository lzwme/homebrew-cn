class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "https:www.underbit.comproductsmad"
  url "https:downloads.sourceforge.netprojectmadmadplay0.15.2bmadplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?madplay[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "bb53d0d999f2179e53c438c9fbcfc1fa57a6dfb0a0e87b144fe8d9f5c91689de"
    sha256 arm64_ventura:  "544e014609eb4449054c2cb5ec02f550ec5ab3619e48faf881db9b71bf9a390b"
    sha256 arm64_monterey: "e66c7d9d05cd323ad4091b07d063ce9ea5d65dd86fbc06e78ac9316522710432"
    sha256 sonoma:         "719d4a1feb495f2c6f4f4e9e9e00689bdf4c4b21ad54add5d91ba97238fbd687"
    sha256 ventura:        "3ad559cb2e38b5b0719a29bade20758642ecfd89c1afb724557b65442ca31e65"
    sha256 monterey:       "0042b125f11f24d15a45f1b231f3ac2e3cda228c67a9ba0ddb1a3f8ceef336bd"
    sha256 x86_64_linux:   "dcf38528c7c57f08ecc8e8ec764d8d7a4be39fb7cec6a37320bb5999cc495e17"
  end

  depends_on "libid3tag"
  depends_on "mad"

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patchesf6c5992cmadplaypatch-audio_carbon.c"
    sha256 "380e1a5ee3357fef46baa9ba442705433e044ae9e37eece52c5146f56da75647"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --build=x86_64
    ]

    system ".configure", *args
    system "make", "install"
  end

  test do
    system bin"madplay", "--version"
  end
end