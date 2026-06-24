class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.7/linphone-sdk-5.5.7.tar.bz2"
  sha256 "35d75edc131ddf017dba40ce5a7060b99bc806e2777be68ab69b876fe4f5bb91"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb934fce6969e3d585bd264f4542b19d0560129044bcefae0c5f0d491311963d"
    sha256 cellar: :any, arm64_sequoia: "6761190151276c6bc5275e2222463c00694da4edebd77493d3bbb0e5a2825a82"
    sha256 cellar: :any, arm64_sonoma:  "0287181221f0b4bac87c387a1d35728db9861c76d2fb7830ecdc89ba1142c3ab"
    sha256 cellar: :any, sonoma:        "547814202e008c84be7081a4f70f40db3e09985856d5c3ca0f82bd483be28afa"
    sha256 cellar: :any, arm64_linux:   "dcfc10252fc7b2fdba6f7673bc3782688284ed0829e0f06491555ac27e0e9b29"
    sha256 cellar: :any, x86_64_linux:  "c731d2824c14d2fc83281620c057a3d131c7b86c49293a4d8c8f9e0bc05c36d3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3" # OpenSSL 4 is not supported in monorepo

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_MBEDTLS=OFF
      -DENABLE_OPENSSL=ON
      -DENABLE_TESTS_COMPONENT=OFF
    ]

    system "cmake", "-S", "bctoolbox", "-B", "build_bctoolbox", *args, *std_cmake_args
    system "cmake", "--build", "build_bctoolbox"
    system "cmake", "--install", "build_bctoolbox"
    prefix.install "bctoolbox/LICENSE.txt" => "LICENSE-bctoolbox.txt"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{frameworks}" if OS.mac?

    system "cmake", "-S", "ortp", "-B", "build_ortp", *args, *std_cmake_args
    system "cmake", "--build", "build_ortp"
    system "cmake", "--install", "build_ortp"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", *linker_flags
    system "./test"
  end
end