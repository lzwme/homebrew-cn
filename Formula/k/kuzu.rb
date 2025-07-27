class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://ghfast.top/https://github.com/kuzudb/kuzu/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "479a9943ad9db3b9a28925438c05563a00e7eb72eaeff07ca21b9d3378069eb7"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94608aca4d744e3536a11933e8ea3cf7381aa3220eaae7bb9ec3fe9ffe467467"
    sha256 cellar: :any,                 arm64_sonoma:  "50459e3361e69c0e46f16866e5b58f798ea626e3c7f2f4af1ebbdd471d502ff5"
    sha256 cellar: :any,                 arm64_ventura: "51e100c08dd1f38764cb16abb16a9ea27f87576cd527511942d797dadb978174"
    sha256 cellar: :any,                 sonoma:        "dae30f4dceec817bd02b1143e7ba0fc4aba0f6d3b4a62886c38a668f4fb49eea"
    sha256 cellar: :any,                 ventura:       "d92b394ecef03c0de03400922a73e86ece84b1c27824952e5a1b3f9794d2cbe1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6fa4fa217f1bf64383b991ec183016445b001a6151de2e1708ce95ebaccc4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bafad12c8ec515a0ea73275ee2b034609682dec2661e6355d42bf2a16435826"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "gcc@12" if DevelopmentTools.gcc_version("/usr/bin/gcc") < 12
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
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    args = %w[
      -DAUTO_UPDATE_GRAMMAR=0
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    db_path = testpath/"testdb.kuzu"
    cypher_path = testpath/"test.cypher"
    cypher_path.write <<~EOS
      CREATE NODE TABLE Person(name STRING, age INT64, PRIMARY KEY(name));
      CREATE (:Person {name: 'Alice', age: 25});
      CREATE (:Person {name: 'Bob', age: 30});
      MATCH (a:Person) RETURN a.name AS NAME, a.age AS AGE ORDER BY a.name ASC;
    EOS

    output = shell_output("#{bin}/kuzu #{db_path} < #{cypher_path}")

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