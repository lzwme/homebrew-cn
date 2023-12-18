class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  url "https:gitlab.linphone.orgBCpublicortp-archive5.2.112ortp-5.2.112.tar.bz2"
  sha256 "710a28c361a863132a2b8dc1577213132524d71df0acab7768d974ba0e9ab2e3"
  license "GPL-3.0-or-later"
  head "https:gitlab.linphone.orgBCpublicortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93e4a6e384e893e3070f50d6d2adb6f7f74a16e3cb12266c35d32cddcd732b72"
    sha256 cellar: :any,                 arm64_ventura:  "472766bdf4005bc27e57ba1e15b897eb2d36f475333a1911b9b898b7bb0b58de"
    sha256 cellar: :any,                 arm64_monterey: "f16871ba304dc46e2b43e9c578a01030eb4d286397fcc50a191c46db2d86d065"
    sha256 cellar: :any,                 sonoma:         "d2343bffa97c636c05e45ccef445d747e45b6989e0a44751e6d7a19e02033b22"
    sha256 cellar: :any,                 ventura:        "b46e51c57cbd296693e9fdaffdff6380919739412d85da7347d028ca03b164d2"
    sha256 cellar: :any,                 monterey:       "682e9f66f372092ff5d3d43f53fbe52955d5ab026786360b4a8d7e5c2f21cff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303382f2205a9957e6166fc89250769044597cc0ff22f0db8f3fa5b6b3d2ae3b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https:github.comBelledonneCommunicationsbctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.2.112bctoolbox-5.2.112.tar.bz2"
    sha256 "458a7eef09951d97f35946b640ab25d6345ebe215413d5d76ef276b8e23a9a7e"
  end

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec"libpkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}lib" if OS.linux?
    cflags = ["-I#{libexec}include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}include
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include "ortplogging.h"
      #include "ortprtpsession.h"
      #include "ortpsessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}include", "-L#{lib}", "-lortp",
           testpath"test.c", "-o", "test"
    system ".test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end