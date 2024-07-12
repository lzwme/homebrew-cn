class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.69ortp-5.3.69.tar.bz2"
    sha256 "94caf199475140293f7e9908c740ba5d9bb8210a85222f3d6bb1e8ad8d7dc11b"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.69bctoolbox-5.3.69.tar.bz2"
      sha256 "6d7a7a51cd1e1c5f9270943ec5ac71e3f16b4ec02530d9c53840134ca7567559"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9495ef0270cea5a74d58b2e8e1622c7f05f4ef246cf9d80344f991a4d763eeb1"
    sha256 cellar: :any,                 arm64_ventura:  "e3dea928e283918eacc622a7ca5ed610b5ff74c2a1496dc9b76a4976ec361820"
    sha256 cellar: :any,                 arm64_monterey: "f09a9a65e7f83cd5e905280728cd26914509a9c02210d6744e2ccae06ea3bfa7"
    sha256 cellar: :any,                 sonoma:         "49a6ef93db682d6ca603ef50e12d0464dc629fe6a26bc12757ecb35eeb468ffc"
    sha256 cellar: :any,                 ventura:        "10f086ac56f47cf589b53b85b3326c8396e2632fac4b5ef97e4876e820e6d0eb"
    sha256 cellar: :any,                 monterey:       "b91822df06b25574fe4e7583571cd96cfd791fa70638ef8b1b0bc0481d3f8c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9e881bfc6a33c0259041ccc81762b6e43792150c5bc11d8fa8c30c5ebd30c3"
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