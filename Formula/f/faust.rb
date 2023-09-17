class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://ghproxy.com/https://github.com/grame-cncm/faust/releases/download/2.68.0/faust-2.68.0.tar.gz"
  sha256 "423bba0bc218348d24dbcf3838a0be315b1f20e0a8f97f42741284f0ee815e07"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f669ca4385f8ad64cf744fa728318e7e25554742596b8f16ac6378ddbc34316"
    sha256 cellar: :any,                 arm64_monterey: "b432e5ac62d28d69b4e917e21a3b6965c4a5eba1efef19601d3627da6be3a240"
    sha256 cellar: :any,                 arm64_big_sur:  "c74cc1f70e889a90c7b19fcaa8ee9093c4ad4eb292c82bbd4ffd39b4f4dfe0a6"
    sha256 cellar: :any,                 ventura:        "915550621389f81fbc7fc7e227b5ea7f2c9e604dc286e2488b25069c89a438e6"
    sha256 cellar: :any,                 monterey:       "b95166a7064904dd6eca10fe79fa5573fe1a2131dc4ab2f7213cb16c80eb5c97"
    sha256 cellar: :any,                 big_sur:        "8356978a5748505893e7688f65b383d07c87d83281e7ea15e4cff4c7e5a557d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "336240c1d431644a6e29a9adf0741427e6496c230abfe128bf35ef83eb1b0a70"
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