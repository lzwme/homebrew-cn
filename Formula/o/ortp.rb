class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.105ortp-5.3.105.tar.bz2"
    sha256 "8907bba9fd92774758557032e9a1988d0f3364dc55866008c6990d2ae60ba0c1"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.105bctoolbox-5.3.105.tar.bz2"
      sha256 "cbf014d799668d3b48f375632fa2d85c4724280c277b3d4069d6a6b103a7414b"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c10a9c518d0169083f54bb6a7283365b64e12cadbafc90ea6c0b96db0969b10"
    sha256 cellar: :any,                 arm64_sonoma:  "9d806163ab170e159094c98acbf2159c3621504ba8b71252938f26df0d6334a1"
    sha256 cellar: :any,                 arm64_ventura: "9d5ab935301aad96e3cbf1c6af2d6775a4be2f20ee62c34c45342ee103299402"
    sha256 cellar: :any,                 sonoma:        "7559525da7f211e9602caf265a4bcfea00aaf9651f0fea6543ec282216579664"
    sha256 cellar: :any,                 ventura:       "98c56294b44cca50c65fc9e762ae51a1a56461b822ba4d430f77d603e0fde255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e0a3016da070d7e52704592d36f1a7c435df601045ba12db914bf3598f467f"
  end

  head do
    url "https:gitlab.linphone.orgBCpublicortp.git", branch: "master"

    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls"

  def install
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

    resource("bctoolbox").stage do
      args = %w[
        -DENABLE_TESTS_COMPONENT=OFF
        -DBUILD_SHARED_LIBS=ON
        -DENABLE_MBEDTLS=ON
      ]

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec"libpkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}lib" if OS.linux?
    ENV.append_to_cflags "-I#{libexec}include"

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{libexec}Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include "ortplogging.h"
      #include "ortprtpsession.h"
      #include "ortpsessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}include", *linker_flags
    system ".test"
  end
end

__END__
diff --git asrccryptombedtls.cc bsrccryptombedtls.cc
index 4bc16d4..278c524 100644
--- asrccryptombedtls.cc
+++ bsrccryptombedtls.cc
@@ -106,8 +106,6 @@ public:
 	std::unique_ptr<RNG> sRNG;
 	mbedtlsStaticContexts() {
 #ifdef BCTBX_USE_MBEDTLS_PSA
-		mbedtls_threading_set_alt(threading_mutex_init_cpp, threading_mutex_free_cpp, threading_mutex_lock_cpp,
-		                          threading_mutex_unlock_cpp);
 		if (psa_crypto_init() != PSA_SUCCESS) {
 			bctbx_error("MbedTLS PSA init fail");
 		}
@@ -120,7 +118,6 @@ public:
 		sRNG = nullptr;
 #ifdef BCTBX_USE_MBEDTLS_PSA
 		mbedtls_psa_crypto_free();
-		mbedtls_threading_free_alt();
 #endif  BCTBX_USE_MBEDTLS_PSA
 	}
 };