class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.4.9.tar.gz"
  sha256 "08b1318beaf92d933c65ae63d16a584d5d6be85b8324bff6718d71cc6ca79862"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b89cc14f2531c0b85807da3e20f3824ed3cc35b0b7d1a9abef17ffc5bf50a12"
    sha256 cellar: :any,                 arm64_ventura:  "5b227eaa062a2d824ea44bb4dcd01c71d0a26006fb368af4a9b5b381b6e3af41"
    sha256 cellar: :any,                 arm64_monterey: "7dcd9c9321156d9b75d10a7b9ccb4a52c2ac8397d949e94bd8e17073344fb561"
    sha256 cellar: :any,                 sonoma:         "0b8c1d4be3e744fe3a6184522b189f1b107e57233a568331e49dc6e4a1e778c6"
    sha256 cellar: :any,                 ventura:        "c2227e57c401f9e8f052d16b75907c4f64770bc41f0058b227a7b28b35fd4a24"
    sha256 cellar: :any,                 monterey:       "d388fc7ca21e1b49d2f8866147a11b3d0dcd10104fcb10c027dc79e37e3b968e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25215c78b36bdd607bf24a0a9a0a0f324e066edbe3c6ea1ed2a157172d0f8b6"
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