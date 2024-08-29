class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.15.0.tar.gz"
  sha256 "68518b1ab6ea5eba77fd481beb97b6f4d26b2bdd93d02fe0778da1f95f865c2c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c532b168de84d818a982b24c5e846a86fba66e91f41f210b8233503d8946bedd"
    sha256 cellar: :any,                 arm64_ventura:  "90ea3d9fe16167fd86cf20fa44c425349edcdabc5fe5f0aa2e90c5cd284143cf"
    sha256 cellar: :any,                 arm64_monterey: "edeb5e73abb2b12c9903a5bc303a6f4e63aede83fa548d93b937f5a0cb40c052"
    sha256 cellar: :any,                 sonoma:         "309efdbd20b22d731547d3c00b7c8dfc5b4ac5282334a86d7ca3ca0122b8939b"
    sha256 cellar: :any,                 ventura:        "131df52b256d90395a5c56084cc0ef728f50d7d26b03f0863d30b0c227db4a3e"
    sha256 cellar: :any,                 monterey:       "3c50676b002d22386851403e2ec53ec4adf47c77a80b4b1e269fc74eb69ffa69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee32fd35817e5c57679d8c4aaa284db272433686cfa98380bfdd122ae3ca5a4"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdint.h>
      #include <rere.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}re", "test.c", "-L#{lib}", "-lre"
  end
end