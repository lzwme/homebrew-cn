class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.72ortp-5.3.72.tar.bz2"
    sha256 "df23091b8fc0e6f5fc9d76ff06371d77b7c62d4b0d347cea37456a4156e43d4b"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.72bctoolbox-5.3.72.tar.bz2"
      sha256 "e8a9b58b6f9963b3c3b3c3df2eb7a276cb5ea8f41348378c29ba6aed18eb03a2"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e37235feb7317c2b1f9b19a949b498d9800ed605fbbd80793e18f27adc05e6dc"
    sha256 cellar: :any,                 arm64_ventura:  "50fa6b678cdc5b212822fea85a8630f5f1640ae89cb2d0130382296cf7b23a2f"
    sha256 cellar: :any,                 arm64_monterey: "3b0891d0268f5c5d59e959f00ec3d9b3749058d233cfc4afb7c88de4644a40d6"
    sha256 cellar: :any,                 sonoma:         "79ac2f93dc7a5616f988a83016e2363c3f66811f256f5727a2e4183273fc1c1e"
    sha256 cellar: :any,                 ventura:        "ca5ee1aa82ef6cb229a9f433c59951b5e02ffe037258a85fe67d1947efb79589"
    sha256 cellar: :any,                 monterey:       "801abf4dffd3cc3f7cf4420a6da8c5c6fd9f2273b4dcdd3ee191eb9ae22c4ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e3f500f0f7d025f184dc7c2949bcec7498123e04b82177d8a6b12f59513757"
  end

  head do
    url "https:gitlab.linphone.orgBCpublicortp.git", branch: "master"

    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  def install
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF", "-DBUILD_SHARED_LIBS=ON"]
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
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}include", *linker_flags
    system ".test"
  end
end