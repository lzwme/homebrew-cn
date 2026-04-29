class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.15.4.2.tar.gz"
  sha256 "7ca796ff20f88ac374a835a7bc3689ee12faae621fcfee9fa5d5de5a8c1cda81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "449a8f5cd5d3afb0dc3407b14d3be64c710e048685e9b66a1492d1414f540a87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e2f4fcde43748b50dc831d9e1b411f238e6aa9ef31ce9ebf7486b7b2930dc10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1598b77622c7e2111adb5414fc6249257f264cb005056295f31471fd6337299e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4995ff8a2853b2fd2fa9203bdb25f5a03b2e9bff390dac1a898f90faf1dafd4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eca97bbee0d9056e9dae624ac9c7e91a4b3ea5520706a6c3ccfef8504d5bbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd6120d9267693ae1bf7b6d08578f10bca1dd27ec258c7fcc7b0d2b9a0caa5e"
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
    bin.install "build/tools/shell/lbug"
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