class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.58ortp-5.3.58.tar.bz2"
    sha256 "18a8845809e2d3939566a5bc27197dd9067b6c71638347a58567835386346f85"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.58bctoolbox-5.3.58.tar.bz2"
      sha256 "d1209fb1ceba09a273ba6fe82995f187b4b2ce56d8d088531bcb06919d142974"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e668845f20bbffd31bf88df016eb8d759de1ae47fec74982b299e9d10859e556"
    sha256 cellar: :any,                 arm64_ventura:  "56dc16e16044031c377f7f6bb9a83ba201c6d6ab82968d16d17888cffa154f1a"
    sha256 cellar: :any,                 arm64_monterey: "d47fba7d090f11b28210c502159402da03921e295ef68885d1df10a3066d6530"
    sha256 cellar: :any,                 sonoma:         "ae8e555cd12191e05609fa3b514464e684954a23842d648a9808df78d94175c1"
    sha256 cellar: :any,                 ventura:        "780e87bb6cbda04e3735006b924d25bac3bce46ef487697f3d0cead1120542dc"
    sha256 cellar: :any,                 monterey:       "6af72a5b4833fab75c564057c013468fa80fabbbf4837a79f83c8e7acddeda97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05283f18a352aab949d4fd6fecc65f05485b77cb34f3b5c4cca9bf13e6e3ed7e"
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