class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https:linphone.org"
  license "GPL-3.0-or-later"

  stable do
    url "https:gitlab.linphone.orgBCpublicortp-archive5.3.38ortp-5.3.38.tar.bz2"
    sha256 "d5d0c8effb45ef7f66db0f5ea867217ae5907c29e0e19ad40b89d92f5517fffe"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https:github.comBelledonneCommunicationsbctoolbox
    resource "bctoolbox" do
      # Don't forget to change both instances of the version in the URL.
      url "https:gitlab.linphone.orgBCpublicbctoolbox-archive5.3.38bctoolbox-5.3.38.tar.bz2"
      sha256 "be5139e0609da93b8f9e71326b24c10292c3cbd1f6cc748e433a78e246d10554"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "15efc2011949f1e09d606b3a4e366e223ee43081f4a576eebb42bef2cce4b849"
    sha256 cellar: :any,                 arm64_ventura:  "d1af238ec080aeba54eaece9015038880676b15f3ac3dc4c3e4c78285feb1c87"
    sha256 cellar: :any,                 arm64_monterey: "abe26f2818dc386f5e64f5acba580c16a0656fff9b396346ad318cc464b379e1"
    sha256 cellar: :any,                 sonoma:         "a22d5c1c97294239173371242d1f6932a57fd1d0bf74d12c98368b99c1f7362b"
    sha256 cellar: :any,                 ventura:        "0905b6371b23e7796acc7bbd79c8aeb170d994b0f3b34b866ecf428c68072395"
    sha256 cellar: :any,                 monterey:       "8cadadfec7195cd7e71a56f3963b9a7dc35f0a2d72554a7c9ea311b72b7d7d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30f3e489d130b3656bec2eab71b744a7683448900f9f55939e3e258dd0454290"
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