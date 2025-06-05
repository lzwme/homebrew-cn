class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.21.tar.gz"
  sha256 "203d69d6f557f6ab303438ad186fca13fd2c60581b2cca6348a9fbee10d79995"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aefe24e1979d2eb094a88996e2f4c9afc7700d889bd0558899477ae65f9408f5"
    sha256 cellar: :any,                 arm64_sonoma:  "9bb1b6fc9fe04daba96797fcaf768efe7baa50ffd992a79168e374bd89cfbcb3"
    sha256 cellar: :any,                 arm64_ventura: "1da4759ddcd8111716a7360976bce1d3b5024c45adc83157d1d8fc6ee11fbe73"
    sha256 cellar: :any,                 sonoma:        "eb39ecfe934d9c76eb142d9d4fb1cc7d711afe0554f4ede816bb5f6cc785b905"
    sha256 cellar: :any,                 ventura:       "9ee954b6e395b2c265970b6bfd263e2341284ff8870b16aec11bd5685380ebaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b8ac1d3604601d1f841f86f9e94eef74f36aba8a9396ee9511709b9269908a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb95c1acaff9d12204a7aba4f983ab3724ef7c4f92090fda56affac021df24e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system ".test"
  end
end