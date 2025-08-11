class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://ghfast.top/https://github.com/kuzudb/kuzu/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "479a9943ad9db3b9a28925438c05563a00e7eb72eaeff07ca21b9d3378069eb7"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7b29b4ae2df088932fab87dc77df54720622fa2c78c2b4203a03bbd4ff13737e"
    sha256 cellar: :any,                 arm64_sonoma:  "0bea81ebab52fc643e4aa036b4bd2d3a2f5eb47a4a5e6c78f61370d582b21c4e"
    sha256 cellar: :any,                 arm64_ventura: "4a08837b40109f1480ee3427a266844f355bc6dc728522f7ab2b28cffeae5f15"
    sha256 cellar: :any,                 sonoma:        "02ddf95116a0657c437e007348ecde64b13603b48951005dc830ffad3e848442"
    sha256 cellar: :any,                 ventura:       "38ce1807674dec3405f1b3393f27ab1c880a0e88e125c0fcc6af7670cefdd680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "694830a475c766ab54840f28e9be11f91791fd6bb8c7b9ed8150609fc968427a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fca3925106804625d590a0d7ea39aedbbc6ebaee4fb1fcb01034bafe5f9b800f"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    on_intel do
      # NOTE: Do not add a runtime dependency on GCC as `kuzu` ships libraries.
      # If build fails with default GCC or Clang then bottle should be dropped.
      depends_on "llvm" => :build if DevelopmentTools.gcc_version("gcc") < 12

      fails_with :gcc do
        version "11"
        cause "error: unknown type name '__m512h'"
      end
    end
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "10"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.linux? && Hardware::CPU.intel? && DevelopmentTools.gcc_version("gcc") < 12
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