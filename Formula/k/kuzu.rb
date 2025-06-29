class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https:kuzudb.com"
  url "https:github.comkuzudbkuzuarchiverefstagsv0.10.1.tar.gz"
  sha256 "b1aa4eb4f542e4dc2f2e25bf02cac827da7c416bd5b431cfde9a1b0281afe85d"
  license "MIT"
  head "https:github.comkuzudbkuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa8d9356c983d7f781d37a537a7cb951c69a6aa98a44fc4f3db3ba834208950d"
    sha256 cellar: :any,                 arm64_sonoma:  "1865a0073646ee4b642f13603b8a540a52cb66d71c35d8f94d59e84dec1f9b61"
    sha256 cellar: :any,                 arm64_ventura: "6c4548acf59828420fc5fb41b9584ea8fadddbdb325cda6e28297117a45f83eb"
    sha256 cellar: :any,                 sonoma:        "0813b2c20da366657f1124013fae8f5a28221e6921279bb5b3c63d6c73c237b3"
    sha256 cellar: :any,                 ventura:       "75a3f322042f512e727f4af8bc8e891dde7e2e714ce559744da51486aa53fa69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24a272122dfaf4380e9cc6bde910c2b0856b1715a296c0203b112e0b8dcbbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d030b009a3a38d0c1138fe92b21ae4c7fe0f5a68a8e7db3ec6529cbaa5cbfe0d"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "gcc@12" if DevelopmentTools.gcc_version("usrbingcc") < 12
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "needs GCC 12 or newer"
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