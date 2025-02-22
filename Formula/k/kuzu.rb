class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https:kuzudb.com"
  url "https:github.comkuzudbkuzuarchiverefstagsv0.8.1.tar.gz"
  sha256 "4d78110e47832eafbeeb6d57efe862a74d2c282233550218ccb1563b0c52b282"
  license "MIT"
  head "https:github.comkuzudbkuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d398a6e349f862f332d0c69057f0ab503f80b6753777a43d8b2f7249a0e3e21f"
    sha256 cellar: :any,                 arm64_sonoma:  "934594dcb163be71eeab324572929d34354880699634d04011895eb834f4d4e1"
    sha256 cellar: :any,                 arm64_ventura: "922c1f9fa1ea0a9ee52fdab82f25c670d84169abb49b0592e4392bd3225fbff2"
    sha256 cellar: :any,                 sonoma:        "ba6af14278b00d20000601c0fed8206e11ec48d1edec6c212f6bd84fb8c0acca"
    sha256 cellar: :any,                 ventura:       "71c1cf9fc580c303ccf289d6f25d3eef7add80a1a36c72807bfd4f011a8c1277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17eeb27f61ff0c5f78d832e2ca58c47122ddfa497739546e2475fb324df89fee"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture arm64:
      #   "std::exception_ptr::__from_native_exception_pointer(void*)", referenced from:
      #       std::exception_ptr std::make_exception_ptr[abi:ne180100]<antlr4::NoViableAltException>...
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib"c++"
    end

    args = %w[
      -DAUTO_UPDATE_GRAMMAR=0
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    db_path = testpath"testdb"
    cypher_path = testpath"test.cypher"
    cypher_path.write <<~EOS
      CREATE NODE TABLE Person(name STRING, age INT64, PRIMARY KEY(name));
      CREATE (:Person {name: 'Alice', age: 25});
      CREATE (:Person {name: 'Bob', age: 30});
      MATCH (a:Person) RETURN a.name AS NAME, a.age AS AGE ORDER BY a.name ASC;
    EOS

    output = shell_output("#{bin}kuzu #{db_path} < #{cypher_path}")

    expected_1 = <<~EOS
      ┌────────────────────────────────┐
      │ result                         │
      │ STRING                         │
      ├────────────────────────────────┤
      │ Table Person has been created. │
      └────────────────────────────────┘
    EOS
    expected_2 = <<~EOS
      ┌────────┬───────┐
      │ NAME   │ AGE   │
      │ STRING │ INT64 │
      ├────────┼───────┤
      │ Alice  │ 25    │
      │ Bob    │ 30    │
      └────────┴───────┘
    EOS

    assert_match expected_1, output
    assert_match expected_2, output
  end
end