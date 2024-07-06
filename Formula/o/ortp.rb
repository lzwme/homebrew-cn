class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.63ortp-5.3.63.tar.bz2"
    sha256 "597f106519ebc59f4d4a6ee971d42a2ddfc787a44e043128b6d15aa135722b61"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.63bctoolbox-5.3.63.tar.bz2"
      sha256 "4d86996367c72b8575a8a06e88e91724f762e8a004eed10280bf7301cf59c146"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "db940139b83cee029aef3283fa0ff7f19b65df6c73c9428929614ef21848a9fe"
    sha256 cellar: :any,                 arm64_ventura:  "49b65346458882d9febcba1632e763aee68d127f3163cbcb8474238cbe4db1ff"
    sha256 cellar: :any,                 arm64_monterey: "be1abacc53ec7a16293a80fbdb5700e9aa67e306caede3253cd1be50f9dcf54f"
    sha256 cellar: :any,                 sonoma:         "81db1213109ef46ac3431c191abe35cc7875837d0c069fed3a550abe47d017dd"
    sha256 cellar: :any,                 ventura:        "958b69c3a7069a503ea080c746d11f082491d97ba89e966a213a81026ee4c079"
    sha256 cellar: :any,                 monterey:       "7a682f7fa3ab6036a6e6e05c604c1bc385edb9a5b67605df0f145aaf7431bc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb92d50ddf7bda6bdbc2b52ed8da3b09ce6cb79fb96b97b6c2cd137841254ca8"
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