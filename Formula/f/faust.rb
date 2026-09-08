class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://ghfast.top/https://github.com/grame-cncm/faust/releases/download/2.85.9/faust-2.85.9.tar.gz"
  sha256 "0cd00968f81357b78df64c25aad12ec94bd4b75bd489ca0449fe7f7b1ad0efe1"
  license "GPL-2.0-or-later"
  revision 1

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d26b3ff30ea27cf6551242e110731893d008c83229d8d5cec39fb15703d6e0a8"
    sha256 cellar: :any, arm64_sequoia: "025c74da0cfc7871106353c691656a4f228004adc6c9b8731448034c07ca3a1d"
    sha256 cellar: :any, arm64_sonoma:  "d0d132fac19ba8f7f4156d90feb46a648f9e9b8cf8c5ae89a17a29550af257f2"
    sha256 cellar: :any, arm64_linux:   "4d9b53b8e3b3bd95412b1f4baf869f7b3ddb8193dc2de69665a743b29c523f33"
    sha256 cellar: :any, x86_64_linux:  "9c8ebfff0c7f11c055ecffc4e02ee65490b25382d85bcec0d60b136829c3e1e5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  # Backport support for LLVM 23
  patch do
    url "https://github.com/grame-cncm/faust/commit/158e371feccc5f61a376276433b19a74d37aedce.patch?full_index=1"
    sha256 "4f5752ac0a4df203d125700b58074b8e22bfce034f14f0e9d159669a0d786dbe"
    type :backport
  end

  def install
    # `brew linkage` doesn't like the pre-built Android libsndfile.so for faust2android.
    # Not an essential feature so just remove it when building arm64 linux in CI.
    if ENV["HOMEBREW_GITHUB_ACTIONS"].present? && OS.linux? && Hardware::CPU.arm?
      rm("architecture/android/app/lib/libsndfile/lib/arm64-v8a/libsndfile.so")
    end

    system "cmake", "-S", "build", "-B", "homebrew_build",
                    "-DC_BACKEND=COMPILER DYNAMIC",
                    "-DCODEBOX_BACKEND=COMPILER DYNAMIC",
                    "-DCPP_BACKEND=COMPILER DYNAMIC",
                    "-DCMAJOR_BACKEND=COMPILER DYNAMIC",
                    "-DCSHARP_BACKEND=COMPILER DYNAMIC",
                    "-DDLANG_BACKEND=COMPILER DYNAMIC",
                    "-DFIR_BACKEND=COMPILER DYNAMIC",
                    "-DINTERP_BACKEND=COMPILER DYNAMIC",
                    "-DJAVA_BACKEND=COMPILER DYNAMIC",
                    "-DJAX_BACKEND=COMPILER DYNAMIC",
                    "-DJULIA_BACKEND=COMPILER DYNAMIC",
                    "-DJSFX_BACKEND=COMPILER DYNAMIC",
                    "-DLLVM_BACKEND=COMPILER DYNAMIC",
                    "-DOLDCPP_BACKEND=COMPILER DYNAMIC",
                    "-DRUST_BACKEND=COMPILER DYNAMIC",
                    "-DTEMPLATE_BACKEND=OFF",
                    "-DWASM_BACKEND=COMPILER DYNAMIC WASM",
                    "-DINCLUDE_EXECUTABLE=ON",
                    "-DINCLUDE_STATIC=OFF",
                    "-DINCLUDE_DYNAMIC=ON",
                    "-DINCLUDE_OSC=OFF",
                    "-DINCLUDE_HTTP=OFF",
                    "-DOSCDYNAMIC=ON",
                    "-DHTTPDYNAMIC=ON",
                    "-DINCLUDE_ITP=OFF",
                    "-DITPDYNAMIC=ON",
                    "-DLINK_LLVM_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "homebrew_build"
    system "cmake", "--install", "homebrew_build"

    system "make", "--directory=tools/sound2faust", "PREFIX=#{prefix}"
    system "make", "--directory=tools/sound2faust", "install", "PREFIX=#{prefix}"

    # Remove Windows files
    rm(Dir[bin/"*.cmd"])
  end

  test do
    (testpath/"noise.dsp").write <<~FAUST
      import("stdfaust.lib");
      process = no.noise;
    FAUST

    system bin/"faust", "noise.dsp"
  end
end