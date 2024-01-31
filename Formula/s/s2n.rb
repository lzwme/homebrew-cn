class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.3.tar.gz"
  sha256 "e42551bdf6595f718e232eb98c4f0e37c7a284f29bfcbc09fa9c0a2145754ab9"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4977832c02fc4bc315a097d010e858a2024428cbaad581464a01ba62c1b7ac5e"
    sha256 cellar: :any,                 arm64_ventura:  "5be55093990ab31c0bb6d9ad79e5d45bef1bbf53a741aab01ac1bf9d89ad27b0"
    sha256 cellar: :any,                 arm64_monterey: "ae56f6eab19b3f882588517a0448299687449938e9d90632fd5bb9a6ec28ada3"
    sha256 cellar: :any,                 sonoma:         "a254daf29dbdbf2ae0d1a0e5841ec7dd2fb836c5ce62c6e2bcd27f7489c08466"
    sha256 cellar: :any,                 ventura:        "ffd4b032dae874614e28a9b7c3feaedcbad09dbe76f682e864e0296a4a0c5657"
    sha256 cellar: :any,                 monterey:       "bc041f1a2a5292022eec5d992164d5fc6c926b10e33ca61b63f4fc44277d9d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553e48126bbb1010b67a2e0b3099fc5cd51c0222bb54281be7959c6abea08847"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "buildstatic", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "buildstatic"
    system "cmake", "--install", "buildstatic"

    system "cmake", "-S", ".", "-B", "buildshared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system ".test"
  end
end