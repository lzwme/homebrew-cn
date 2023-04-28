class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://ghproxy.com/https://github.com/aws/s2n-tls/archive/v1.3.43.tar.gz"
  sha256 "6fd844f290b37ef3b08854eb2dbd7951f9cb7452f1c4280267833e9eaa4b564d"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf53afd5c1a9479a28f172533d995fe398dbe45d96559f29962c88c50206091e"
    sha256 cellar: :any,                 arm64_monterey: "cef5c896526bdfe25ebfa40dce3790bd88526731a920e867ab5b40ef21887d72"
    sha256 cellar: :any,                 arm64_big_sur:  "4bf91a1b4815039f3a8ca3029184f3e5a9455c50887428d87782fe1f7a46e197"
    sha256 cellar: :any,                 ventura:        "b58d29b581d9a7b0c260b5d2cbf045d8a8642b24b39d821dd8eaeb3a94ade6b2"
    sha256 cellar: :any,                 monterey:       "3aceee3ae7736d3db132c5ecad0e802575a3f2b162128cdc82b55de34e8f7d59"
    sha256 cellar: :any,                 big_sur:        "175f416b1d9035106dd3834ed5587de46b8474c24b0403cfb877232022698d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3514fe09941952d624b82034ad4b1ab279e07c0188a5aec1681bfd39e6b4ec4"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end