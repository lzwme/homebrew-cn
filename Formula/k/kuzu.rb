class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https:kuzudb.com"
  url "https:github.comkuzudbkuzuarchiverefstagsv0.7.0.tar.gz"
  sha256 "93b0e192873c858bc3162c3167dfb9dc7c5583606f77c9a24ca0ccaca8afb72b"
  license "MIT"
  head "https:github.comkuzudbkuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9e77670704d49e7f98347fe09901325e97f4154526a9102f16d85a0653cf0df"
    sha256 cellar: :any,                 arm64_sonoma:  "f63ade46595f398899568e026273a7b295f0e4ffd90ce30a914df377615d98a6"
    sha256 cellar: :any,                 arm64_ventura: "62534f32ead7e6998853fd0fc2da2ec42a575a9b8ad5df2650929bde88c62999"
    sha256 cellar: :any,                 sonoma:        "7e0d72c93ff51b31f45f2341f9514e5877b3b2b6f2c7bf542905082c4e4be8e7"
    sha256 cellar: :any,                 ventura:       "e49907d9c9494d18e22aadfad45b286c66cadf4381a8e16fe92fcb3dcd8926f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a4b4e1ffbc3f7df1bf41d364d7a56409cab56574c187bd231f0f7547125309"
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