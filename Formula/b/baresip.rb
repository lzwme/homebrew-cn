class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.22.0.tar.gz"
  sha256 "a9e7884fa796f47640fe0854485229a0357eb9a6913fa7909bc92bab6148fe04"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "590d0de042f13081efb7144252f8f66b8b5ed33d020ddb8f94f00f7426fe30a7"
    sha256 arm64_sonoma:  "f1cfb07b037973a6d339070266b5262136fea773c53e21b00b5a719f5c4839c7"
    sha256 arm64_ventura: "15384f69a9cfcf959970a3aa6561eada5e68da0a4c778d7a186f1667cf3feb36"
    sha256 sonoma:        "257ba35c130aeedb30076f286766371d4be2975311fdb4df4ee39dd57185eefb"
    sha256 ventura:       "ed38983352198fada76f12fbea3e6a9b99b3eb366267990f537e6aa8193297b2"
    sha256 arm64_linux:   "981f612120b8ff8d4c3404d375a304202b1356795a222a4ad64ea72ce0ade116"
    sha256 x86_64_linux:  "f176c290c9f77c72429fc606423323b7c87b1a3beadf91fbda8fde3a7566cdd3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end