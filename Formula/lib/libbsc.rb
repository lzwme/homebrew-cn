class Libbsc < Formula
  desc "High performance block-sorting data compression library"
  homepage "http://libbsc.com"
  url "https://ghfast.top/https://github.com/IlyaGrebnov/libbsc/archive/refs/tags/v3.3.11.tar.gz"
  sha256 "3a71c406981b5b53d968b2647b87f1520212a1fad7c5c98e6953b81d7805c4b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a6f90f8763ba58c4f43c8e34d7d57c108515fe671c448a88ab5bee028c52e52"
    sha256 cellar: :any,                 arm64_sonoma:  "3a29fa2a2e9934217ff57f75932d5ce0831a4e5d9a19f3f6a61cc3ed07d26285"
    sha256 cellar: :any,                 arm64_ventura: "7266e96a7b5bd4a981cf430e3366093cf9b1fe9471a92a86fb9a11140d031800"
    sha256 cellar: :any,                 sonoma:        "2a297388b75e2f4d2b9977419fa319e3481aa4f168d1b00be1691e219127dab2"
    sha256 cellar: :any,                 ventura:       "f3c4355b4ccb577e55de0c30efdc97fbaf4844fde01534230c817f68847ed1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef22ed9b13ec3627549e5a8ec57951537184ae7536748aa1b0f6abe35b3c9750"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "bsc", because: "both install `bsc` binaries"

  def install
    args = %W[
      -DBSC_ENABLE_NATIVE_COMPILATION=OFF
      -DBSC_BUILD_SHARED_LIB=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bsc", "e", test_fixtures("test.tiff"), "test.tiff.bsc"
    system bin/"bsc", "d", "test.tiff.bsc", "test.tiff"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.tiff").read),
                 Digest::SHA256.hexdigest((testpath/"test.tiff").read)
  end
end