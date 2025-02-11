class S2n < Formula
  desc "Implementation of the TLSSSL protocols"
  homepage "https:github.comawss2n-tls"
  url "https:github.comawss2n-tlsarchiverefstagsv1.5.12.tar.gz"
  sha256 "718866ea8276f4d5c78a4b6506561599a4ff5c05b3fccee7ef7ad6198b23e660"
  license "Apache-2.0"
  head "https:github.comawss2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b6b3cdc527a1fdad8badf89c7eb91024944fbb408a4dab1158322943848a503"
    sha256 cellar: :any,                 arm64_sonoma:  "77e72cc4c0e1a4f2cba4e3292a5db6707d7c031dff62ef7bc27e5edd2bd46a27"
    sha256 cellar: :any,                 arm64_ventura: "3460435b3f2020bf3fd3ed15118ba826db074e81c92450ecc639150a8748cdbc"
    sha256 cellar: :any,                 sonoma:        "8f8b3cfb14bb0174e922e4156f9d90ff93e08624c20a998eaae129483d601e0f"
    sha256 cellar: :any,                 ventura:       "949368569184b6a3c945d0664213d2106f97780bffdb63249fd7fca0813e976b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c73c0635f650da305081219d63060f4f7441f4a0c0b20fea0529fcfd92e578"
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