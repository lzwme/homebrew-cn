class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://ghproxy.com/https://github.com/grame-cncm/faust/releases/download/2.60.3/faust-2.60.3.tar.gz"
  sha256 "1088b31ad2a6175ff27807afc33c5929c33e97a7d09a1995e126bdda9940fc1e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e71deead9314f7f4cb64235770f25f5e5dc1131f96f66cbc1ca795333ee534a"
    sha256 cellar: :any,                 arm64_monterey: "09571115f90c6d6a79dc07081de33230dd6a6c80aa497d4fcde552f5c21859aa"
    sha256 cellar: :any,                 arm64_big_sur:  "84ff66598a53ec07b5de84b63a53b89fb53e5ff204274408e2b05e640ccff13c"
    sha256 cellar: :any,                 ventura:        "d2bb8002080dc48fc45519bb653c0cd61e7402f0565c7624378cde382f6a80b2"
    sha256 cellar: :any,                 monterey:       "6ad803949023a14483f2d4c982436aa8ac46f5688ae92f057b938d8957603f9a"
    sha256 cellar: :any,                 big_sur:        "e7500004d69947efc6a4dacd905baaf2d0f7441ecd42e2248434dc5d68646031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed2562a4684e2ddd76c85b59134b342dbe039697bfa581f5ff765543fca5cced"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  fails_with gcc: "5"

  def install
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
                    *std_cmake_args
    system "cmake", "--build", "homebrew_build"
    system "cmake", "--install", "homebrew_build"

    system "make", "--directory=tools/sound2faust", "PREFIX=#{prefix}"
    system "make", "--directory=tools/sound2faust", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system bin/"faust", "noise.dsp"
  end
end