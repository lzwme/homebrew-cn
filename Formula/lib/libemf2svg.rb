class Libemf2svg < Formula
  desc "Microsoft (MS) EMF to SVG conversion library"
  homepage "https://github.com/kakwa/libemf2svg"
  url "https://ghfast.top/https://github.com/kakwa/libemf2svg/archive/refs/tags/1.8.0.tar.gz"
  sha256 "090f84711968608b3a2324e06d1314c5b581248ee834edc0e7dfbc015f0619e2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ca9eb3c1b5575ca3b415f7b2c2b8dbf5d94ed8ef17bc76679801d3c68b9eafc"
    sha256 cellar: :any,                 arm64_sequoia: "be1d2b4b7e587cea6f7e2ba6a2522660225243469e2e15c79d2e8fa49d374e57"
    sha256 cellar: :any,                 arm64_sonoma:  "61e85f92f97aa75d063c67a11901313fc17ce8782f0026ded9e0444afa796be9"
    sha256 cellar: :any,                 sonoma:        "22114b481d38b92a99787f4f2ac1408f4ab4d9f631df7ee20465515d610d4640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f544fe01c724d02c928ac39e0fd784adbb62bc56ebd04d8df985fda33e2b44f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0df182fe862359cde0951486c681258d8ec0db5fe7208a18e97ec8f3e2fdfb"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    # Bypass to check brew setup
    # https://github.com/kakwa/libemf2svg/issues/50
    inreplace "CMakeLists.txt", "Darwin", "PASS" if OS.mac?

    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]
    args << "-DEXTERNAL_ICONV=iconv" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/kakwa/libemf2svg/raw/1.1.0/tests/resources/emf/test-037.emf"
      sha256 "d2855fc380fc3f791da58a78937af60c77ea437b749702a90652615019a5abdf"
    end

    resource("homebrew-testdata").stage do
      system bin/"emf2svg-conv", "-i", "test-037.emf", "-o", testpath/"test.svg"
    end
    assert_path_exists testpath/"test.svg"
  end
end