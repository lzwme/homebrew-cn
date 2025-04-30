class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.4.12ortp-5.4.12.tar.bz2"
    sha256 "73500254f630861a8c2f213cd5fdde698b2cae915d15cdb7c38e220ad05da933"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.4.12bctoolbox-5.4.12.tar.bz2"
      sha256 "1833c0dd2630cadf87686c1f14771cf9c173f6fd04a527f47213de7e0f7d0a7c"

      livecheck do
        formula :parent
      end

      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3bc8c110106d005b1d42f068747aac2e8dff0a3715172601f0fcd9f23a467d28"
    sha256 cellar: :any,                 arm64_sonoma:  "e7992b8263e2584329f85445e9f7f0b7d9aa942abcd1382b386938ff16cdb954"
    sha256 cellar: :any,                 arm64_ventura: "dc3a8cce8b7e7d942b662bbf07785fca8d40d7cfaf784d9a5c08a7593c4bd64c"
    sha256 cellar: :any,                 sonoma:        "92e8d74449192cc95cfa7c01e0327f6b5659e5811299523c3ef27821b6c53599"
    sha256 cellar: :any,                 ventura:       "97f2f3683b7525bf607eb084ac8cd45821afdb437dbffaa4e2f93d024df55a1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53167867d7ea521ca48c6a5666a8f312f18c4af106008394b442b083b0c9fd5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad8b35b17de2a2feaa622d5407738dc93aa9b59393f7b11e1b40b9aeeefa7b49"
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