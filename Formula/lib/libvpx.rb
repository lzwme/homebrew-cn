class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://ghfast.top/https://github.com/webmproject/libvpx/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "1020f184046187baa2985dbde38e0691f49c44088bca7a1842b0236c6081dc0a"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0b25798cd931cf522c100b7dafbdb75a4bf9f3758e3036e91bef071375d3ec09"
    sha256 cellar: :any, arm64_sequoia: "2476b7be93b0a47ca091583c16e576871b50e7e29cb84efe9f9b5bd805793371"
    sha256 cellar: :any, arm64_sonoma:  "c5cc847271f8da90dfd2b72db35fa134fa5cfdda346d7077f41a57a27b2c7a7f"
    sha256 cellar: :any, sonoma:        "041dc03d0f23bff4696145e2205befdf6a9612d04401a0e4b60f9b619e8fb323"
    sha256 cellar: :any, arm64_linux:   "91cb1cd1ae26b6327ee06e4b8e3c9031829d5592c186848286aaa031c6dec0b5"
    sha256 cellar: :any, x86_64_linux:  "813cf7ed3afbaf502065971561bf0d17e0da569a4d70ac32d0ee1867cf164423"
  end

  on_intel do
    depends_on "nasm" => :build
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