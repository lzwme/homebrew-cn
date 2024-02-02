class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.15ortp-5.3.15.tar.bz2"
    sha256 "d406c85e2256f4a3f5194c8627fd06c11936b6fa9d5d36c6929e50faf4e2cfa5"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.15bctoolbox-5.3.15.tar.bz2"
      sha256 "d78b6bfd85a1e05bde8bd9da3aaa0bf1ebd67e1d3fe02dc24f3ecb55efbd0cfa"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b19a3066fbb348143fd3c70c4725a346448aeb5118986140f50a44c1fd9aa640"
    sha256 cellar: :any,                 arm64_ventura:  "4ed9a315fca675f0a2e3a439e7e5760eeeb7fbdeec9fe0b8256ee98504cb4321"
    sha256 cellar: :any,                 arm64_monterey: "64ebcb71d21750655854fcc5b756ee7dbfa8b4970189c2cec1e404a6cf75e5f7"
    sha256 cellar: :any,                 sonoma:         "886544eed32176c750b40aacf91b007c9d861cf646ea027864881d79fcf8e0c2"
    sha256 cellar: :any,                 ventura:        "b9370b2dfbeec78bf65bb5c31269da346485175113f714ccab0447a3f54a8db3"
    sha256 cellar: :any,                 monterey:       "eb96b968a5a9c6c2841ec2c7ef49cb840370989cabcd9a7f554f45baa153e3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21a59752b54ee1ce25445c1075133e0783415b3f28f7201ff2fe0385b42d523"
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

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end