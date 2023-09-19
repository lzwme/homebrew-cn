class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://ghproxy.com/https://github.com/grame-cncm/faust/releases/download/2.68.1/faust-2.68.1.tar.gz"
  sha256 "d4ee30e2444bed55b593c6c70ec4e330b71260819d4011b37d8c9b9c061e810f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b45850608b669abcaefa6099dfee88d8764535be63a74303d013ff1c80adc4ba"
    sha256 cellar: :any,                 arm64_monterey: "bccd0d3ea0ba6960e305bfc2e5e9c3766be367d292e3d57e6001785f67634b78"
    sha256 cellar: :any,                 arm64_big_sur:  "0ea493bf42bdf6d80e42b2cd4a5fad15a481fc513435d0f509a43479d077eb3e"
    sha256 cellar: :any,                 ventura:        "c5bb3f47a95767ddcff657283c1bc71a3072e287c8ab631b5d349556cdfc6faa"
    sha256 cellar: :any,                 monterey:       "5b6547c0a22ffa0727458d5e3c1551d89a55333d979aba4a7113975e59b065ed"
    sha256 cellar: :any,                 big_sur:        "95673475939bf786e04159be8d99e4be2e1ee27a2690235895d85c3b208fa662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c99d180157e67a5dd0e8b2eea2a915ce46a3af0b447b9628799c1ddf41e330c5"
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