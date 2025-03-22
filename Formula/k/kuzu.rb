class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https:kuzudb.com"
  url "https:github.comkuzudbkuzuarchiverefstagsv0.8.2.tar.gz"
  sha256 "e802083bd0d4337210bc4e49261f22a3fc6535cca1214c054a7ebcffbddc8b43"
  license "MIT"
  head "https:github.comkuzudbkuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a19ac88070f4bdf5a644e96a8e781b96e14472f85edcd3f62d8761c8cc5fefa7"
    sha256 cellar: :any,                 arm64_sonoma:  "3ef2e0d449b23c811d328b7dfe79fd8a0a4222f2281fcacd7ec5c3a08ef9ba6f"
    sha256 cellar: :any,                 arm64_ventura: "d6cc5e8c40385bd0337d772ab5280b8dcb79b981122644670a45afb2643d4736"
    sha256 cellar: :any,                 sonoma:        "80bd178664fa223908b9df2c9c52fc54f1f65c2e5086adecb8d3eb89ff6ab04a"
    sha256 cellar: :any,                 ventura:       "e33cf3d0648cda5ea7d04d33c5bae524b8d631764cf7385d83c9a5b68bcd3d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdf8c891eee21313582baa026ed188e1c60c6aa8e2c6176e97722fae71d8444e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bb1a201fcbb64a450da340c951d39e248e1a51ecddc1b615f74453e3408f732"
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