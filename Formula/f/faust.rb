class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https:faust.grame.fr"
  url "https:github.comgrame-cncmfaustreleasesdownload2.77.3faust-2.77.3.tar.gz"
  sha256 "3685348ba2482547fc7675b345caea490ff380814c5dcabc8a5f772682617c0e"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3296230f502adb8a95c9a5e0e7c556c9aa44a37a9ee6b6f93aaa99601d54a637"
    sha256 cellar: :any,                 arm64_sonoma:  "f8eaf80d3fc8a735f874de8e1b29f3c416118f954990e9d6862e59dade531e99"
    sha256 cellar: :any,                 arm64_ventura: "246299770a0e972861a72dce99656a3eb466c43eca0f76c7ded87868325186d1"
    sha256 cellar: :any,                 sonoma:        "26fa0ecf918c6dd768a2e319b76ba8e2acc5de5b0f39bc58807e523cacda1adf"
    sha256 cellar: :any,                 ventura:       "52c0024aebe3f787036012d0e5766b016146a18d91657f165cd0bae412418070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aeb6e71cb7393c351df9fd884ed1a3b2b3cb80de8b8466c0a0c1f690c21ac7b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@18"

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

    system "make", "--directory=toolssound2faust", "PREFIX=#{prefix}"
    system "make", "--directory=toolssound2faust", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system bin"faust", "noise.dsp"
  end
end