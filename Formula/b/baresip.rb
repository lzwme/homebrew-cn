class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.20.0.tar.gz"
  sha256 "df3df6b94bb72f4105a542246e02800db05cd6877088b0567c6169b94be5fea5"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_sequoia: "f0a99d4671e701fb58f07805ea6aa9ad1f3858172fb029a1483be17d1d7a81eb"
    sha256 arm64_sonoma:  "8b5c3c284d764787cde269b18bf24d354b48a2abe3f59c2c49690ca5f919e0a7"
    sha256 arm64_ventura: "f739cfad633914309183fe419dbcfca1545c8f4a5fcf17cb97cbfb332ee5210a"
    sha256 sonoma:        "42914f4453a0c564fb362a7b6cce30c5d54892b4c608ded19955555d7b855062"
    sha256 ventura:       "4d3d33fe0ff1bff32b603d5ba1b0e746a11abaa052606f0550fed1dd7dd07093"
    sha256 x86_64_linux:  "7a8faa242541b40e03621b130341d50b06357b6f8e0ad2b0552f68910af8c160"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end