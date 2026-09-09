class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "22f2988274a43309676e2e996d3b2da6e2ca3e074c5bb7a69c5f9d484d98d511"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2ef1ab9b7971894c9ece61084f9819d897882731d879107a8c9a2a0be7d68ff8"
    sha256 cellar: :any, arm64_sequoia: "f2f87a812d0ace8430d02ee3cd50dadd6c6313a967fa3fdc0581f824fdd07018"
    sha256 cellar: :any, arm64_sonoma:  "95765625bcb97f3eff5131143be6e5f5987fd8ccdff5b68a8560653bfb637d91"
    sha256 cellar: :any, arm64_linux:   "ba7fb216e209fe3de57932772f4e2a7b87b3c1e9434f7976f296a6be1f616fa4"
    sha256 cellar: :any, x86_64_linux:  "248f4d5a53e9770bb961d7243cd2922fdebc8063351e3dd1538ea199121b94f7"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Requires C+++20 support for `std::atomic_ref`"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unwanted headers and libraries for `cppjieba`
    rm_r Dir["{#{include},#{share}}/cppjieba/*"]
  end

  test do
    # Upstream versioning up to patch version, so skip for 4th number in version
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end