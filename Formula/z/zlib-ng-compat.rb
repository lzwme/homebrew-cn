class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://ghfast.top/https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-ng-2.2.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-ng-2.2.5.tar.gz"
  sha256 "5b3b022489f3ced82384f06db1e13ba148cbce38c7941e424d6cb414416acd18"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "26b7b200c89a18067105f0dae14ffffe20283ef7a0f48032ec8bd7c0e28cdf89"
    sha256 cellar: :any,                 arm64_sequoia: "a0527abe9725436d79275302cb33392d18667008582ae462cddb531622eda868"
    sha256 cellar: :any,                 arm64_sonoma:  "e03cedd3457eb46c54ab51d971b9a3f4baef060dd4f7da60c65f2146fb464852"
    sha256 cellar: :any,                 sonoma:        "42db7cf7e9a6e8fa9d6f38cf93f537a32663c932dd3063529466f5cb9a5278bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "769bb1465997f0586b5f0b2082e01a1e9fa817a3c09434d0367eb70b99f45422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b6cc9b9d780d119cd7932104cd55df405e7cc09cd9fb2c9125f2156842f3bca"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  depends_on "cmake" => :build

  on_linux do
    keg_only "it conflicts with zlib"
  end

  def install
    ENV.runtime_cpu_detection
    args = %w[
      -DZLIB_COMPAT=ON
      -DWITH_NEW_STRATEGIES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "homebrew-test_artifact" do
      url "https://zlib.net/zpipe.c"
      version "20051211"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

    testpath.install resource("homebrew-test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", lib/shared_library("libz"), "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end