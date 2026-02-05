class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://ghfast.top/https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-ng-2.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-ng-2.3.3.tar.gz"
  sha256 "f9c65aa9c852eb8255b636fd9f07ce1c406f061ec19a2e7d508b318ca0c907d1"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c68344fcda141002ce8baefbfc4b9cd89da914794d9045f7e677ec0a6cd517a9"
    sha256 cellar: :any,                 arm64_sequoia: "48de3de7772bd13eee2a371fc3a39377962682e325e7deaa6ec5ed4503ef4048"
    sha256 cellar: :any,                 arm64_sonoma:  "46ccc739bfabf38f5b8dfbe7348679a0931ce83c470d396a3d1c2802b2ca5e0d"
    sha256 cellar: :any,                 sonoma:        "2a8f6d23e346425ab4e1cabb04694080447a1f486326cc93cab5af4091053912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac366c1fa7ffa88ee7b22e6f820ebd45a865eca7bea812b4751294840e5971aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ae6d39b4674cecdb6de15180dd613779ee391f90623fa6d10ab2d45c9d2dd0"
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