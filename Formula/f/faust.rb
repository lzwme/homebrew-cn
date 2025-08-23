class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://ghfast.top/https://github.com/grame-cncm/faust/releases/download/2.81.2/faust-2.81.2.tar.gz"
  sha256 "c91afe17cc01f1f75e4928dc2d2971dd83b37d10be991dda7e8b94ffab1f1ac9"
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
    sha256 cellar: :any,                 arm64_sequoia: "6803fd272d5011a7a23b1f7bbe528ab803d0e578ff401e1f0877bbe4c350b688"
    sha256 cellar: :any,                 arm64_sonoma:  "f6344ac3fd54a96abcc354bb424c531140ecc6fd8363e85acf3d3da935c1dbf1"
    sha256 cellar: :any,                 arm64_ventura: "a1c32caf8239ca0014ed2fb4d4b8084b4867b7748ad92e45a525bb7271bd0153"
    sha256 cellar: :any,                 sonoma:        "898630c7bb9e6bddaca3a4634675a7e4d9b37c82d9d1439f1c807fc57214df20"
    sha256 cellar: :any,                 ventura:       "d88fcece153ff7726519b03614825f8c0ec361d924ffdd4fa31c85c648582fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb6598f8898487cf68c9ece61f89153f1f7eb614c897a1a4751d3f05d11fd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07aaffadf2107489d02f837e11a33e2a11f963d8e6a761004384289ecdcdee19"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@20"

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
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system bin/"faust", "noise.dsp"
  end
end