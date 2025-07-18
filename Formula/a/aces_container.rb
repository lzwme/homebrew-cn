class AcesContainer < Formula
  desc "Reference implementation of SMPTE ST2065-4"
  homepage "https://github.com/ampas/aces_container"
  url "https://ghfast.top/https://github.com/ampas/aces_container/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "cbbba395d2425251263e4ae05c4829319a3e399a0aee70df2eb9efb6a8afdbae"
  license "AMPAS"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "470a323cfa40f185682a38aa7ecb04256cebf17b0b854e444cb89d02c09c7d0c"
    sha256 cellar: :any,                 arm64_sonoma:   "93e409e911279df2bdf9c910341e1ba17a64aff066b042a51eba8894bf1bfea9"
    sha256 cellar: :any,                 arm64_ventura:  "15fd9fe1558e49d54f45bdd8b7dc124bca31732212fe502d48be8d0ba716997e"
    sha256 cellar: :any,                 arm64_monterey: "2f2429a4ee7fdb7d58ee635a6d653f799d1f22ec9dddabab6b3b7e5d4d06b5de"
    sha256 cellar: :any,                 arm64_big_sur:  "0d1d573d700561a2cc168c20f2de1dd752553f142575c64c8b3235cfb2dc6133"
    sha256 cellar: :any,                 sonoma:         "6a201930c698e76ae0ee1d705d4de5504a524770999dbc6044a0dc093f819e92"
    sha256 cellar: :any,                 ventura:        "411b910c990eb426a348c74ed2e7f40a46fba871b56314f3b2ea311f8a220ee6"
    sha256 cellar: :any,                 monterey:       "86a5c8b346d870672b1e2af38be9f1c20b561e4f46f92dbd8f9e2b3d617cd0f9"
    sha256 cellar: :any,                 big_sur:        "ab9e2e475f4b03c4d2ff8ecfb31f1254d862dcadb2baf8d76d143fd4ef8c74ee"
    sha256 cellar: :any,                 catalina:       "26cfdcca70d0fb62834376bfbda89af0acd57f0173a4a3c9bd0f77adf748c8b9"
    sha256 cellar: :any,                 mojave:         "5f2c4a76a3a1082e3d969143455c8a47b8d05d7251424b7e8d821b4e73f46a9e"
    sha256 cellar: :any,                 high_sierra:    "4297afa069f1cd305e93038ed43260b3643f0bd27f39e33355061fc111fb7f6f"
    sha256 cellar: :any,                 sierra:         "6b276491297d4052538bd2fd22d5129389f27d90a98f831987236a5b90511b98"
    sha256 cellar: :any,                 el_capitan:     "16cf230afdfcb6306c208d169549cf8773c831c8653d2c852315a048960d7e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2db09e9407396d6028ca3f4d5753568fddf26fb066608453da5ccbc09fcf1763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73f4e399a8e1e405f0f0fc0c3e514e52a22abe17b8e518868074c118cd1116a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "aces/aces_Writer.h"

      int main()
      {
          aces_Writer x;
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lAcesContainer", "-o", "test"
    system "./test"
  end
end