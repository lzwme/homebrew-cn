class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "fcd790936fe83650f6579c741fe79ce295604bbcab905fa389fdc778da83377f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0a9eea76de542cce842fa6234ed230bf12fdccdd5efc21dcc8fa2944a57539b6"
    sha256 cellar: :any, arm64_sequoia: "6252631fd50cc3539db37cfa0d10a70e2d00c5b4037d70220b89d69223a057ac"
    sha256 cellar: :any, arm64_sonoma:  "86bfc7e7f06b1be2bbf27bb1087550594d82d107b98cd2f276f05d81a3c06ec9"
    sha256 cellar: :any, sonoma:        "25f4e69cd6b3dd501aa51026f94fa5607a4df38239c4e8f5e8c093c69f140dd5"
    sha256 cellar: :any, arm64_linux:   "5adff10770cc354fcf62426488a27f02c25e822fdb40d3ff43d5801dee33753d"
    sha256 cellar: :any, x86_64_linux:  "c180516b2f37ead1d521cc68e538ff4fab5960d0b77d7430af8732ca225ceef6"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

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