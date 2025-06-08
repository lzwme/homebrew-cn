class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https:fizmo.spellbreaker.org"
  url "https:fizmo.spellbreaker.orgsourcefizmo-0.8.5.tar.gz"
  sha256 "1c259a29b21c9f401c12fc24d555aca4f4ff171873be56fb44c0c9402c61beaa"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url "https:fizmo.spellbreaker.orgdownload"
    regex(%r{href=.*?fizmo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia:  "4e3cac7e500d651ad426903ea1016ab8c1814b75c9f8bd421a089b308c8a2ce7"
    sha256 arm64_sonoma:   "40879942bfcd0d7fe5b9ffbf4ae0392d0e93b3ffc148aaa06b803388284ab23f"
    sha256 arm64_ventura:  "878df159a06663acf65f7038069c45e7b679269c5e8dcb9c4490f512f1cd2826"
    sha256 arm64_monterey: "869fedbd10336fffd09d9f28cb0459dba50d54e5d99f9977c57359a4af33f6fb"
    sha256 arm64_big_sur:  "71a6701b5983df601d714b574d480ac3943efc0f67f119b43a6c37bd3b4cef2e"
    sha256 sonoma:         "802b7299660b696f26bce7418aa0d214a896bf08bdae7e14767923775aee3dbf"
    sha256 ventura:        "3bb045bbcbb685260968f288bce323bb4d13c10a242c24dd67811d90d9c35d09"
    sha256 monterey:       "d34d8d73e7d009ec869a41d39e058a2cdd5b53584f4d6e91de6007808c17e420"
    sha256 big_sur:        "2b316eea30d6bc1c9b1d031a33d267320ff05ec61da20d5b3698c760d3acd1be"
    sha256 catalina:       "40d46b98fd262acb6bfbe87d2716a51a715367be1f38d8a7a027b071649bf5cd"
    sha256 arm64_linux:    "6c553882a7549dab6864ee7b1519091bb94a0f483c7ccdaabb66b0f510bf5261"
    sha256 x86_64_linux:   "9fe334a5cf5e393d868f48d5be496001315fd76a84058458c7244b4970ffda4d"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libx11"
  depends_on "sdl2"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin"fizmo-console", "--help"

    # Unable to test headless ncursew client
    # https:github.comHomebrewhomebrew-gamespull366
    # system bin"fizmo-ncursesw", "--help"
    system bin"fizmo-sdl2", "--help"
  end
end