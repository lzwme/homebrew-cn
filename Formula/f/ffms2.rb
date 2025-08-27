class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://ghfast.top/https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_5.0.orig.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0a1d6f052e06051371623f731946110cad79123151db292cc4d186fb94f3556"
    sha256 cellar: :any,                 arm64_sonoma:  "4fbd4f74769ff25633afad16be708287d67d5fc9aee93890bcaff0f7b3adc340"
    sha256 cellar: :any,                 arm64_ventura: "bdaf50764f8601b9ac38a5127340845ad64595106c6cc19411fb693dc7f6e40d"
    sha256 cellar: :any,                 sonoma:        "3958cecdaf384930812f7475b9d3c947220716c3ac8f9e7c0c40c7c9e8162972"
    sha256 cellar: :any,                 ventura:       "7d664fba6da8627ff010caa2ee8e078b8954fc18589437df2ea9209c5a74d20f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1053142277f22aa1c3f8f074484d7c841a2e76946cea9eb470604757d6bae26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b2975baf7bf148e9cc67a99d5736331704ed251e0b7aec1634a13ec55a0e5c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg@7" # Works with FFmpeg 8, but siril (a dependent) doesn't.

  uses_from_macos "zlib"

  def install
    system "./autogen.sh", "--enable-avresample", *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-videosample" do
      url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
      sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
    end

    # download small sample and check that the index was created
    resource("homebrew-videosample").stage do
      system bin/"ffmsindex", "lm20.avi"
      assert_path_exists Pathname.pwd/"lm20.avi.ffindex"
    end
  end
end