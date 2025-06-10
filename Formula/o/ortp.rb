class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.4.21ortp-5.4.21.tar.bz2"
    sha256 "cec4ce593a813534e4aed04608434987ab249123f83ac6f4e03a72e8bdf0644d"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.4.21bctoolbox-5.4.21.tar.bz2"
      sha256 "68ec982af58022e9ce469a5868bf2b78267dcfd849a8c00bd6a3019c0692aba9"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c262dabf3721f3f9c254b5085ecc68add887eac5163ecaabb001cf53e8d2dd4"
    sha256 cellar: :any,                 arm64_sonoma:  "7223f886e41bda862bdc4d80d9df19bcaf0f7bdca21bc8b90c3b5abf24309cdd"
    sha256 cellar: :any,                 arm64_ventura: "f6d9ac85207989bad05aecb5a9b2993978141a5445b9480b6c43f4d29cef73ef"
    sha256 cellar: :any,                 sonoma:        "1dc8a92abc001c7b42e990688e1e080f0b4c175b91883c3f60ab63f50d82865b"
    sha256 cellar: :any,                 ventura:       "8a3ae3d1a00622bfce1c85ef809ff3b2848bce64df06f511735837e63845882c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a54d5589fd1893f4ee79404bb0e1843c38fd9ca43e877ae3edecd25dc551a0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558b10114f9d35920068ffa6353fed0363db08229e259242fbf68d41284bf418"
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