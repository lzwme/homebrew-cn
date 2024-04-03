class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https:faust.grame.fr"
  url "https:github.comgrame-cncmfaustreleasesdownload2.72.14faust-2.72.14.tar.gz"
  sha256 "dcd5aaf263c59d34c385e65c4f4c5b85b0e9435e57cbfd79bb67a01e5780acf0"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33e1e96ec7cffa86b4b4c2cf8466e362b6f143bd1c4f45d918ba7fa9bb13dc18"
    sha256 cellar: :any,                 arm64_ventura:  "69016809383ee5e600016046134631e358fff1da0b9894431e8ec2d09cba04f1"
    sha256 cellar: :any,                 arm64_monterey: "c68a373bbc7cfde1c8f5d6aa7076b55bf39c30e26dfb11aeb15e5057d7b0749a"
    sha256 cellar: :any,                 sonoma:         "e3a3aa3a384ffe62c9b13f3edd015470ca5a9902ecbbdb88600e4990dae5dde1"
    sha256 cellar: :any,                 ventura:        "17fc281e8b36d4a801ec001a719d0c6b17ea58fb3f903ebefbdb77fd1489bc0c"
    sha256 cellar: :any,                 monterey:       "7c9bb7b04e5677ab0f729d97dc8181b36a1407853da33239661e5edc8c5a90ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9890dc00a2c7ca0b192b527982c86dbd1758a26ba909e7ec2fa5e60a5b62fdf6"
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