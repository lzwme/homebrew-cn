class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.44ortp-5.3.44.tar.bz2"
    sha256 "7c0993d86207b9672ee56b1a9ecf55d9f171485f04050fcf6a59b566ee4ca611"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.44bctoolbox-5.3.44.tar.bz2"
      sha256 "faec0bf9ab8e9d2a946a5711fccc35672ed03a6b186d55fc1a9dc6e861289b59"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2f2edeb2b7ccc77ede33d59d0182bf768b11bcb5059fff8b2a74e60dba2188c1"
    sha256 cellar: :any,                 arm64_ventura:  "4205d56cd166388a199bd5a474fe526118e7fc25458c151a6efe9b05dde49470"
    sha256 cellar: :any,                 arm64_monterey: "8e8458cf1967d13145968aaa15f31afd800917b8a6083432476f797d8610e6e8"
    sha256 cellar: :any,                 sonoma:         "f639819710f16ae92fc095109c82c145c7ba763974bd2480726a3450a67a64d5"
    sha256 cellar: :any,                 ventura:        "5fec0d37dd27bba0ad365c905e7aeaaed2c30a94c6ef444dc666fe6cce49171e"
    sha256 cellar: :any,                 monterey:       "09d8047b44c74cb2a71a4f327e92b0323bf12b06ba37aef444c15087d1252225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e907a51b13109711eef5bb3ddbdb9dba560f2b41f04d0e6b6e1ad458e3b1ed6c"
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