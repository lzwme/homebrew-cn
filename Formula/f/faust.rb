class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https:faust.grame.fr"
  url "https:github.comgrame-cncmfaustreleasesdownload2.69.3faust-2.69.3.tar.gz"
  sha256 "169a2f1e8a95e159c78c734c1c5dd818bf5c95b3b002a7efd9f6bb8589357062"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b10239664df9182dc940ca3d42ee409e6ee7e2c233114bbedf7a9f1124ea74b"
    sha256 cellar: :any,                 arm64_ventura:  "efd5871259abeb6d736455c656cb63f4ed97f98bbe58d787f6fcd4b090c8e973"
    sha256 cellar: :any,                 arm64_monterey: "aba61128e2e466380f972aacefc1cd73301b8e37fa15cf5b23245ea014c81a12"
    sha256 cellar: :any,                 sonoma:         "e30ae2c5392aae062f21a78e39af48a561dd8bf1019c435833657c8bfcfa1a88"
    sha256 cellar: :any,                 ventura:        "b416c41d804617677762acd1803f025c63727772ab4c12a4d652e2fe7012f69a"
    sha256 cellar: :any,                 monterey:       "f1be2c99dd6f4a745e797249bb8f57cfd6f802b219458c217af8fecdfbb2e323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de742f79179072cb2ffd695662f463c11551db2df34136c968cef02f76ad88c"
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