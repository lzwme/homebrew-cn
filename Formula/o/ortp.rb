class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.4.17ortp-5.4.17.tar.bz2"
    sha256 "a13d6bfca531f5d5f40fec2e2c8d1adacaebc3cb403badfecbf00189ba129691"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.4.17bctoolbox-5.4.17.tar.bz2"
      sha256 "149f4b8f5b24c438de6e7ace057f1f9b612ebae144e6acf7aeaaef585138aa3c"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  no_autobump! because: "resources cannot be updated automatically"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9245a7bdeb2906e31d533a37380236aefe5d8a97e15550f9883837cca8996a64"
    sha256 cellar: :any,                 arm64_sonoma:  "7d39febc5d0737a3d4f96a9c4fef63b0476d4964fe5d8eb08f8be61d06ae54b6"
    sha256 cellar: :any,                 arm64_ventura: "4547db407b0a92cf02e1c97c9291232571e673c96d922e6ab168970790278c21"
    sha256 cellar: :any,                 sonoma:        "654ef531330b85960e2d4091c475dcd4941a877711d094bb595d848b8d8c1aff"
    sha256 cellar: :any,                 ventura:       "898b08e4e4387f1b3414d62a84d0131783faea7fa506307de17d5df569d75506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52b69b57d5f0b2d7b1cae2d040a6e5b57f4079f1b057bf29f83aa3c13c46b634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ad50c25941e4c94f0bf0d057debc39f6cd5ae76defa08d4afa82712ed5dd41"
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