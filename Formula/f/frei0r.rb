class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "a0fbf466e5d1965ab0a40842d50a63bdac8bfa1cfbce2f8e5b73eb862ec1182b"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d725f194eeadc389eeb002a233830fcd3d6a38684f2f351443ec363eda7ffe17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "915d4d421e774ac6dbdf2fa156e0b70e7f214faaf06d5b9705155430974a3b34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a37e1c6e99a752501a56ca6abbb4d4ec102788c1724999f1b6940d6a219a9c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "658b29ae18f71178db185c708d6328db7a9c90f167a21fc426b8daefcbc92f4a"
    sha256 cellar: :any,                 arm64_linux:   "6fb10eb695fca71fb6a21f17b9781ce966d4189753edc40b1ae1788cf4395bc3"
    sha256 cellar: :any,                 x86_64_linux:  "909f8c1a7cefe096b48b35217d5d5004c3c4de5ddc575d707678c4bac73365fb"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
      -DWITHOUT_CAIRO=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end