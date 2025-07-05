class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/downloads/x265_4.1.tar.gz"
  sha256 "a31699c6a89806b74b0151e5e6a7df65de4b49050482fe5ebf8a4379d7af8f29"
  license "GPL-2.0-or-later"
  head "https://bitbucket.org/multicoreware/x265_git.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a2270c67fc2ea5a74824435cd72a9ad1441f9052d8490ab3e56ab5781bd7ad3c"
    sha256 cellar: :any,                 arm64_sonoma:  "c8d3df545085b8f60e7c00a147ccbd90f4f9cb46a3cd275e2474d8e71648207a"
    sha256 cellar: :any,                 arm64_ventura: "aa56445287b9782addb79abe348821ecd198170b17ffb6cc74735d7ed60b9bac"
    sha256 cellar: :any,                 sonoma:        "303948272d75e643cbe4465e5ac39fee0b2f1f38c8b56763b62e6652fa257c1a"
    sha256 cellar: :any,                 ventura:       "1d120ed18c3c98cefffd108236ffb658f4022827b5dbc434666ffa9568d80ed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84411e12f00238bb69bb1e383c6b6959c4cd3a7e417075ab81d7101eebf145de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b24399f347c1ad1f1981a711ce9a60cd2f87da01e998f5dcd1d04e62e7fd121"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  # cmake 4 workaround, remove in next release
  patch do
    url "https://api.bitbucket.org/2.0/repositories/multicoreware/x265_git/diff/b354c009a60bcd6d7fc04014e200a1ee9c45c167"
    sha256 "f7d3ce261c4b0cd461b55ad00de38ffa6a7cc2fa13ae6f034b3e46d8bb3cb6a8"
  end
  patch do
    url "https://api.bitbucket.org/2.0/repositories/multicoreware/x265_git/diff/51ae8e922bcc4586ad4710812072289af91492a8"
    sha256 "56c78f60cbaac61a44cb6e9889ece3380f9b60d32a4b704e274d9a636a16379d"
  end

  def install
    ENV.runtime_cpu_detection
    # Build based off the script at ./build/linux/multilib.sh
    args = %W[
      -DLINKED_10BIT=ON
      -DLINKED_12BIT=ON
      -DEXTRA_LINK_FLAGS=-L.
      -DEXTRA_LIB=x265_main10.a;x265_main12.a
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DENABLE_SVE2=OFF" if OS.linux? && Hardware::CPU.arm?
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # FIXME: Workaround for CMake 4.
    high_bit_depth_args = %w[
      -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
      -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    ]
    high_bit_depth_args << "-DENABLE_SVE2=OFF" if OS.linux? && Hardware::CPU.arm?
    high_bit_depth_args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # FIXME: Workaround for CMake 4.

    (buildpath/"8bit").mkpath
    system "cmake", "-S", buildpath/"source", "-B", "10bit",
                    "-DENABLE_HDR10_PLUS=ON",
                    *high_bit_depth_args,
                    *std_cmake_args
    system "cmake", "--build", "10bit"
    mv "10bit/libx265.a", buildpath/"8bit/libx265_main10.a"

    system "cmake", "-S", buildpath/"source", "-B", "12bit",
                    "-DMAIN12=ON",
                    *high_bit_depth_args,
                    *std_cmake_args
    system "cmake", "--build", "12bit"
    mv "12bit/libx265.a", buildpath/"8bit/libx265_main12.a"

    system "cmake", "-S", buildpath/"source", "-B", "8bit", *args, *std_cmake_args
    system "cmake", "--build", "8bit"

    cd "8bit" do
      mv "libx265.a", "libx265_main.a"

      if OS.mac?
        system "libtool", "-static", "-o", "libx265.a", "libx265_main.a",
                          "libx265_main10.a", "libx265_main12.a"
      else
        system "ar", "cr", "libx265.a", "libx265_main.a", "libx265_main10.a",
                           "libx265_main12.a"
        system "ranlib", "libx265.a"
      end

      system "make", "install"
    end
  end

  test do
    resource "homebrew-test_video" do
      url "https://ghfast.top/https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath
    yuv_path = testpath/"RTn23_80x44p15_f15.yuv"
    x265_path = testpath/"x265.265"
    system bin/"x265", "--input-res", "360x640", "--fps", "60", "--input", yuv_path, "-o", x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]

    assert_match "version #{version}", shell_output("#{bin}/x265 -V 2>&1")
  end
end