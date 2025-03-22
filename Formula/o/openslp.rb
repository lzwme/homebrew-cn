class Openslp < Formula
  desc "Implementation of Service Location Protocol"
  homepage "http:www.openslp.org"
  url "https:downloads.sourceforge.netprojectopenslp2.0.02.0.0%20Releaseopenslp-2.0.0.tar.gz"
  sha256 "924337a2a8e5be043ebaea2a78365c7427ac6e9cee24610a0780808b2ba7579b"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 sonoma:       "9f8b91c18c4a8e0738618531ad35f6068daa27cb6069362510622592113aada5"
    sha256 ventura:      "517653bc27072c320f9159e57040c51d5ba0b4ea8b234bb5af9af55a9aea9f42"
    sha256 arm64_linux:  "7f3de41c36959025ce20d867cfa90c065fba46d872b055d0b7c2a2e6a631b44d"
    sha256 x86_64_linux: "aa1988503f1e9688dfd80e0331392ab29a053e62197b60653e933ee1bc681efb"
  end

  on_macos do
    depends_on arch: :x86_64
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end
end