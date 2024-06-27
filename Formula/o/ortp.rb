class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.61ortp-5.3.61.tar.bz2"
    sha256 "e83d77b99e00efa5eac61d08057f206d78e612ec8a84000ec3963bec5f4630d9"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.61bctoolbox-5.3.61.tar.bz2"
      sha256 "076ca4c4171b68d65ccbd93b815e53760954e092251abc1498b8c7ae54a1b3af"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c88380549cc9fdb8688790ea0a5018c460f0cf424f84183069c83a537f0cf42d"
    sha256 cellar: :any,                 arm64_ventura:  "75eba742ee249725a77f8a18fe632fe71797e6f8783d6b835e24c7c83fcc2163"
    sha256 cellar: :any,                 arm64_monterey: "efbd5fea3a77cea9159163d3d19dbcd855f0a6f8f69948a4196ab3744d2b9fa5"
    sha256 cellar: :any,                 sonoma:         "2349de9ab6888d99a45da73ee3f2ae395748ca07e9f8e2b3f527f0f295366bd8"
    sha256 cellar: :any,                 ventura:        "bab7fa8f46634276e200a70cd3735481e01738d6971da383e7ac564f9e252606"
    sha256 cellar: :any,                 monterey:       "89ccea8f2c04e5ef0130d56fbc756b4cee469cd29a7ef275c3a82ba5167368eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8db9cfdb6ccb36af49d9fd4030e61073c9a3e486b4283961511b39d09dee4f7"
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