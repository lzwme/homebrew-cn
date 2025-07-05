class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://ghfast.top/https://github.com/webmproject/libvpx/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "26fcd3db88045dee380e581862a6ef106f49b74b6396ee95c2993a260b4636aa"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f2d553f2f66735705b3962dca32a4a16bbfbe443c17898c0cea110d13bb012d"
    sha256 cellar: :any,                 arm64_sonoma:  "7eff9f3e0be6983c8018e445dd1b3242fa6631a2b2d410b1db989436224af387"
    sha256 cellar: :any,                 arm64_ventura: "8fc8387529166f2b569d3f804921d5ba26a3db0ce3c825338f3085f67dbf7675"
    sha256 cellar: :any,                 sonoma:        "2b32497dc2978a8ac931cbd93bbcd8669b49421a5ddc8f0b1313a2977f05f121"
    sha256 cellar: :any,                 ventura:       "3202d78ad6ceb9b6b329d146cd41675618ea9e09c34cf1557a4ed2986826e139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcf22715ec604a46f2fbe8abc185b10d68348437c923998afaf66ab757e8f182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c61f077f7fe903a03c721d3e67bb0a93a53f9e00fd2f5119aed6a71101c159"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  def install
    ENV.runtime_cpu_detection
    # NOTE: `libvpx` will fail to build on new macOS versions before the
    # `configure` and `build/make/configure.sh` files are updated to support
    # the new target (e.g., `arm64-darwin24-gcc` for macOS 15). We [temporarily]
    # patch these files to add the new target (until there is a new version).
    # If we don't want to create a patch each year, we can consider using
    # `--force-target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc`
    # to force the target instead.
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-runtime-cpu-detect
      --enable-shared
      --enable-vp9-highbitdepth
    ]
    args << "--target=#{Hardware::CPU.arch}-darwin#{OS.kernel_version.major}-gcc" if OS.mac?

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end