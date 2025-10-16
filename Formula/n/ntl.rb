class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://libntl.org"
  url "https://libntl.org/ntl-11.5.1.tar.gz"
  sha256 "210d06c31306cbc6eaf6814453c56c776d9d8e8df36d74eb306f6a523d1c6a8a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://libntl.org/download.html"
    regex(/href=.*?ntl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a403f10e051b7654eb42b3e0d5f1ec028e96eb44ce25673962aeb1cfa0adaf65"
    sha256 cellar: :any,                 arm64_sequoia:  "5b5d6f2e3c4aa10a77d9b526811afda574c87f29a2e56776866755be59996efa"
    sha256 cellar: :any,                 arm64_sonoma:   "ef6c7df391853c86ee1859fd85b677fa6e233d7f60f70921b97a5c0fb61ac330"
    sha256 cellar: :any,                 arm64_ventura:  "8495ee2f2c83602778defb01dab2fe3f61c9c3bab35598cc5eb642ba02ef8afb"
    sha256 cellar: :any,                 arm64_monterey: "2bd16013e5715eefa223b3a72a08e725e2414a2d0b849199a253aef506ee9ba2"
    sha256 cellar: :any,                 arm64_big_sur:  "972f6f6fdf45e71f8d852a5ab162189f14bb1f800692af4466b5672e75ff62cd"
    sha256 cellar: :any,                 sonoma:         "83f23838c8d74f136eef54295632baf31eab7bf906ff0fb002f6312be454fd6a"
    sha256 cellar: :any,                 ventura:        "987890c24404d66b16f9c6ebd5ef2baa9dd2f8ce35c3965e8e457c932e63acab"
    sha256 cellar: :any,                 monterey:       "d882847db4da92801d989382e682e6ba372263942ef42eafdd16e2672cdeb107"
    sha256 cellar: :any,                 big_sur:        "e108c06f39537cdc58cd6e7f681395ae069c381af5e0c95abca97d1ccc90ec9e"
    sha256 cellar: :any,                 catalina:       "b97739b3b8de3daabe0d76cec3e29ef47f4bc85e6197054aec6d10f6b8f1a4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "640bacf81998649350ec51bd93978b6f723e2631bea4e136321413ee33b90dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0612d19a82889b93ddae2920ccd148644bee62f74c0c39662c20bb8447fe6c2"
  end

  depends_on "gmp"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "src/libtool-origin"
  end

  def install
    args = ["PREFIX=#{prefix}", "SHARED=on"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"square.cc").write <<~CPP
      #include <iostream>
      #include <NTL/ZZ.h>

      int main()
      {
          NTL::ZZ a;
          std::cin >> a;
          std::cout << NTL::power(a, 2);
          return 0;
      }
    CPP
    gmp = Formula["gmp"]
    flags = %W[
      -std=c++11
      -I#{include}
      -L#{gmp.opt_lib}
      -L#{lib}
      -lntl
      -lgmp
      -lpthread
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end