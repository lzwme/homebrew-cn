class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.4.14ortp-5.4.14.tar.bz2"
    sha256 "cc91f7bb8ca5cfab4e333f1e1655a3ff0d82fa61ca93117178872980e7e286a5"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.4.14bctoolbox-5.4.14.tar.bz2"
      sha256 "494245128330401f45abce89bf9b1db9b404462ac424a957a15926d558dba6eb"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28cfa7ebd711112926c7ee3039126766119382cbc5effb0883c6fb96ca321068"
    sha256 cellar: :any,                 arm64_sonoma:  "06efef44fbafe7f3f24ceeb9b5751731883ca27c9e7bb5ddd3d91936ac6fd575"
    sha256 cellar: :any,                 arm64_ventura: "8069650d982d765bf198d5147b741e8ecdada18acd883511de3deac224a0a8df"
    sha256 cellar: :any,                 sonoma:        "e5a336f5106ee94fbd034147a91752d620e32e3c20378b6e47170187aaccd387"
    sha256 cellar: :any,                 ventura:       "7b22cd5ea7b43fac6867eb5e831bd260e9dd290c9839b0b55e78fec870ffc4fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "822a72497d4d27b23d3beb2b3576d45ab595753d4f7fd1901078860d6cee18b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "003c0e1f938497084cbbd1a9b4e5def10d20d502fd5f9471ab67e62f4a39690b"
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
index cf146fd..8886b2d 100644
--- asrccryptombedtls.cc
+++ bsrccryptombedtls.cc
@@ -80,8 +80,6 @@ public:
 
 	std::unique_ptr<RNG> sRNG;
 	mbedtlsStaticContexts() {
-		mbedtls_threading_set_alt(threading_mutex_init_cpp, threading_mutex_free_cpp, threading_mutex_lock_cpp,
-		                          threading_mutex_unlock_cpp);
 		if (psa_crypto_init() != PSA_SUCCESS) {
 			bctbx_error("MbedTLS PSA init fail");
 		}
@@ -92,7 +90,6 @@ public:
 		 before destroying mbedtls internal context, destroy the static RNG
 		sRNG = nullptr;
 		mbedtls_psa_crypto_free();
-		mbedtls_threading_free_alt();
 	}
 };
 static const auto mbedtlsStaticContextsInstance = std::make_unique<mbedtlsStaticContexts>();