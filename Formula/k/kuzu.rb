class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https:kuzudb.com"
  url "https:github.comkuzudbkuzuarchiverefstagsv0.5.0.tar.gz"
  sha256 "80ed050ffe2b1dbd474515ffa417106477de4fbbccb1fbbf4505edb49d33c2ea"
  license "MIT"
  head "https:github.comkuzudbkuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "68d5860c7230c3cfc3ac6c570c6179e6d38dc6652adf588add2d88f5680deb64"
    sha256 cellar: :any,                 arm64_ventura:  "77fbd9163b9f489ea801938bba9c28ff834bbbf97d9a20b1fe20dae8c8a55852"
    sha256 cellar: :any,                 arm64_monterey: "bdcb97afa6c1e8adfd95c998a603b4a1d726a2b15a388f10ad04ca15e355cb7e"
    sha256 cellar: :any,                 sonoma:         "d795fd95004fc4f41011baa6240e1ab85af976307bbd89d306f91ccbd3f48c1e"
    sha256 cellar: :any,                 ventura:        "ebe347859e24b9d604286b7911fcaa562e74d89b728194ddcad1e5aa815bed3b"
    sha256 cellar: :any,                 monterey:       "d657b748c0111b1d1e230f4d736b1ad6d042d17292db8a7ea91357bc6c273a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "420b606afe4a17616d936ef365469e9c14ea213022e9b179267c807ff0f492f3"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

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