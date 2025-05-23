class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.19.tar.gz"
  sha256 "cb67993d43b39f583ea864d29b028bc258cc0866704f45eedc7ca064e48987ac"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c94191a3781b2d6803d2a3d7e868c4b23223d3b24051b9883836ee5009ba08a5"
    sha256 cellar: :any,                 arm64_sonoma:  "867fa53e0f5212db1ff3075da741e2bf4d5b1ac1abffc0e4f524d2a580a67bfc"
    sha256 cellar: :any,                 arm64_ventura: "8ae228ba2e5da572f42a0f654ca37b006db1a9769a1dab36187c6848d0a5ece0"
    sha256 cellar: :any,                 sonoma:        "2f823e556d3bb3fbacd01b54b5d8084e33974a339290f05c8a57bf441498ff5e"
    sha256 cellar: :any,                 ventura:       "6473053292be72320fd45c9d1642005859a6953acd28d57814b7166a7ee17e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04dce8faa1d52528cc430072f65fb967be069cc0c41d964ec6d0c09c0ec1e3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28eda52c38972b038e388cff21d4ec7112c01cb5d4d9d4d3b236a395dcc4db25"
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