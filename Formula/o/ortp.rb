class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.53/ortp-5.4.53.tar.bz2"
    sha256 "d07ce7fa78e1d229783bc6279252f92ee4ed57c839ce8274e9157589e4973143"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.53/bctoolbox-5.4.53.tar.bz2"
      sha256 "ca7b9ed97fcd3528ec0aa38f197f06df138fe1de9ed5158f8c89a857c5eebff8"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "901bbc448e3eaae71393a6180bef6f0a83bd282a23fa860228126ff1abca0be7"
    sha256 cellar: :any,                 arm64_sequoia: "06257b9c7c8858d95e04c47a98fa1a4571dc2e57161353a8f26b485067643cdc"
    sha256 cellar: :any,                 arm64_sonoma:  "19e9b7f8768b3e415b8300e880537a4fad2b05d555a2c080e407b1810cb319c3"
    sha256 cellar: :any,                 sonoma:        "3f3280d6ac4fdea85219c0fbcc23178bffc00eff6ab298fdeeef3ad0e30f2244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e775e30bc8c377f90f634f6ad768e11b61ff379cf85f117b8f6ad1060fc1245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04258d60d2df1440c5a253f83a428434d3cc41342c5e6698a5552e24fcbe62e"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
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

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    ENV.append_to_cflags "-I#{libexec}/include"

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{libexec}/Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}/include", *linker_flags
    system "./test"
  end
end

__END__
diff --git a/src/crypto/mbedtls.cc b/src/crypto/mbedtls.cc
index cf146fd..8886b2d 100644
--- a/src/crypto/mbedtls.cc
+++ b/src/crypto/mbedtls.cc
@@ -80,8 +80,6 @@ public:
 
 	std::unique_ptr<RNG> sRNG;
 	mbedtlsStaticContexts() {
-		mbedtls_threading_set_alt(threading_mutex_init_cpp, threading_mutex_free_cpp, threading_mutex_lock_cpp,
-		                          threading_mutex_unlock_cpp);
 		if (psa_crypto_init() != PSA_SUCCESS) {
 			bctbx_error("MbedTLS PSA init fail");
 		}
@@ -92,7 +90,6 @@ public:
 		// before destroying mbedtls internal context, destroy the static RNG
 		sRNG = nullptr;
 		mbedtls_psa_crypto_free();
-		mbedtls_threading_free_alt();
 	}
 };
 static const auto mbedtlsStaticContextsInstance = std::make_unique<mbedtlsStaticContexts>();