class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://ghfast.top/https://github.com/baresip/re/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "be6bc1adb74bac8ea866e7fff655f9c9bcd9dbceebf7337649c7ac834c7028dd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e1ec091c8bda61d0a8848d078f519fc66852bf5be67ace00163f8ced60c5cc2"
    sha256 cellar: :any,                 arm64_sequoia: "2b775c95e27bb0efbbab252db37c78dbc4ed47a1c96dfe7e867d77a6b40d04c4"
    sha256 cellar: :any,                 arm64_sonoma:  "d4f532cf113353710686a29adb131d3b366c3506426589f9f5504584e2fd37b4"
    sha256 cellar: :any,                 sonoma:        "4a06200d20f6cb554366026649ea83f001736718a792443e5f5e196b99b0f34a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f873587a29add341a2721846e801fbcb4a5965dc6c04dba61251a0c8cd2bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d9563cdb9d0ea9e2d9f6e2093685eb207177628b384ee75999bc68710596f6"
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
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end