class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https:github.commicrosoftmimalloc"
  url "https:github.commicrosoftmimallocarchiverefstagsv2.1.6.tar.gz"
  sha256 "0ec960b656f8623de35012edacb988f8edcc4c90d2ce6c19f1d290fbb4872ccc"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d9a764e439f2e359eba8facff541f0d3caf9ef01aa4254d2be89da79f9ef45e4"
    sha256 cellar: :any,                 arm64_ventura:  "9083c60d82bd99de8d9f13bd81a71e147318b7abbe8876667ccfa2779e6a2aeb"
    sha256 cellar: :any,                 arm64_monterey: "436636a26215dad9fb5d000e9908c0c041b52d7312ac60fe544c38f109515d57"
    sha256 cellar: :any,                 sonoma:         "b8c50f2126b1acf989d58b53e3fff3eac3a6fe3192a061b278fb81c00c4250f9"
    sha256 cellar: :any,                 ventura:        "b24520a7a07418769ecfc1c860313b62d8d961682372e56f5ffe85d5c91440ca"
    sha256 cellar: :any,                 monterey:       "5efbbc1761a0e39db60f4acfd47f8383c4a53a426a0ae3e1b752a976b7450b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac493ad9e25c253a1d7f6b2973e2f55cc1dcaca0e3b8d666ce72707cacf7e6b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare"testmain.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output(".test 2>&1")
  end
end