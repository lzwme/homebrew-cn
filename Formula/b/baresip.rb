class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.8.1.tar.gz"
  sha256 "5a9cdc05e84578e0d71e59485f80d12c087fefaf006b5bbb76a26967c89c10fa"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "73992033cea9f73b60c95aee98a1ad73f0ac86ed9833a0080e53e2f3b9ac69bc"
    sha256 arm64_ventura:  "40f4a5456c83ebbabe971d4005039a774ce08ba87b5a27a27ea68952a1ad88de"
    sha256 arm64_monterey: "4da8fc19b6db205626b68d3d06c3a68288f84f53a6c4ed2ea1dd49850366ff85"
    sha256 sonoma:         "8bb5f49dff9dccfe92142c312428f116953aa3b29478a0a87b18666a60e7a020"
    sha256 ventura:        "1c15370471eb2683e6a888ee58c820d4cc893054800c523049ea456ad63045e5"
    sha256 monterey:       "c04797022e0fe03c87f77f3d8bc7492616377ac89058a6140a8048197de8b46d"
    sha256 x86_64_linux:   "d4086ccbd796908d86d93fc3e0b5ab15f99867328ac64726ee9f028d5d7ea535"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end