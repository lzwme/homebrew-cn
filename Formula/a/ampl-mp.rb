class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https:www.ampl.com"
  url "https:github.comamplmparchiverefstags3.1.0.tar.gz"
  sha256 "587c1a88f4c8f57bef95b58a8586956145417c8039f59b1758365ccc5a309ae9"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d02c9a51954b17ab0a6caa31093daa7be212239b957d2224b773aaaa19b89c59"
    sha256 cellar: :any,                 arm64_sonoma:  "02f9efaecf470dffc6bff5b71530d0245b342f0e3805f73a5741b15a175e348a"
    sha256 cellar: :any,                 arm64_ventura: "cf8589ed55bdfa5612fe9f4efc698eed1000e332446900798b1d4ebcd9f4e77e"
    sha256 cellar: :any,                 sonoma:        "fdf52601bd4c9990a80d1a14600d7c8649f2597bf4af38c966f9f806835eff44"
    sha256 cellar: :any,                 ventura:       "48756d110b0bac36eec0f33e181ad12f68632cb3087ccebb8451ef1d31798294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14117080e712ec6bcfd79084440b9264783a4567b9f31368bf8fa7109d718f58"
  end

  depends_on "cmake" => :build

  resource "miniampl" do
    url "https:github.comdpominiamplarchiverefstagsv1.0.tar.gz"
    sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
  end

  # Removes Google Benchmark - as already done so upstream
  # All it did was conflict with the google-benchmark formula
  patch do
    url "https:github.comamplmpcommit96e332bb8cb7ba925e3ac947d6df515496027eed.patch?full_index=1"
    sha256 "1a4ef4cd1f4e8b959c20518f8f00994ef577e74e05824b2d1b241b1c3c1f84eb"
  end

  # Install missing header files, remove in > 3.1.0
  # https:github.comamplmpissues110
  patch do
    url "https:github.comamplmpcommit8183be3e486d38d281e0c5a02a1ea4239695035e.patch?full_index=1"
    sha256 "6b37201f1d0d6dba591e7e1b81fb16d2694d118605c92c422dcdaaedb463c367"
  end

  # Backport fmt header update. Remove in the next release
  # https:github.comamplmpissues108
  patch do
    url "https:github.comamplmpcommit1f39801af085656e4bf72250356a3a70d5d98e73.patch?full_index=1"
    sha256 "b0e0185f24caba54cb38b65a638ebda6eb4db3e8c74d71ca79f072b8337e8e2c"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DAMPL_LIBRARY_DIR=#{libexec}bin",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec"bin")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("miniampl").stage do
      testpath.install "srcminiampl.c", Dir["exampleswb.*"]
    end

    system ENV.cc, "miniampl.c", "-std=c99", "-I#{include}asl", "-L#{lib}", "-lasl", "-lmp"
    output = shell_output(".a.out wb showname=1 showgrad=1")
    assert_match "Objective name: objective", output
  end
end