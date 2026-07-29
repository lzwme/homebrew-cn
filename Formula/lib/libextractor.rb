class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftpmirror.gnu.org/gnu/libextractor/libextractor-1.18.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.18.tar.gz"
  sha256 "726cf3474dd9e809910ee8b5aba64bfccc1a4fb111dcbea2e24276a618562760"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "bd8ee5b4ff7b8a767ab6ffdfbd4e588a646fbdc0c1343d15d316143103b9bf09"
    sha256 arm64_sequoia: "5ea6278946b4b979eacd127d7e5382a8651c79be27a515ecbec91cb96f1fc384"
    sha256 arm64_sonoma:  "10efb8f4de3d70e31677a573039274180447b35a5c18d5950e160d9ba61fa978"
    sha256 sonoma:        "b5d385aefe51f1c20fa2b8fc818eda926756e79d1545f0f142c6c198fe765aa1"
    sha256 arm64_linux:   "f6288a5aada2207e14e1b919cac376ad378db4fdb562edc5180567baff361aca"
    sha256 x86_64_linux:  "53ab54897e2c470732fea01659aeec6de84cfa9c7083872ff27921d0c01287f0"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "csound", because: "both install `extract` binaries"

  def install
    ENV.deparallelize

    # macOS defines ntohll as a macro, clashing with the local definition
    inreplace "src/plugins/qt_extractor.c",
              "static uint64_t\nntohll (uint64_t n)",
              "#undef ntohll\n\\0"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "Keywords for file", shell_output("#{bin}/extract #{fixture}")
  end
end