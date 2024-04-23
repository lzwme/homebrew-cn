class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https:rocksdb.org"
  url "https:github.comfacebookrocksdbarchiverefstagsv9.1.1.tar.gz"
  sha256 "54ca90dd782a988cd3ebc3e0e9ba9b4efd563d7eb78c5e690c2403f1b7d4a87a"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https:github.comfacebookrocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e351224f85d7395607446df6ab6090980cc361876fef0bebc8616d7bb58fde0"
    sha256 cellar: :any,                 arm64_ventura:  "928e66cada899a01081204ae43863c9a692a5ddccb15c80cb9012dfa2178b7f4"
    sha256 cellar: :any,                 arm64_monterey: "4ba6eb79ee4a5143ff0f188bfaa59e821789b725033f0bf5d0575293de4a4fff"
    sha256 cellar: :any,                 sonoma:         "1f0cb75a9246dda6ae0885708044a1229ef4b2631aca3da2af4d9dd9eeca321b"
    sha256 cellar: :any,                 ventura:        "291b196a6c27620c5a50205db8b1e951b8ee5c5d0a8f378dc6a7eeec159075c7"
    sha256 cellar: :any,                 monterey:       "70677c48cc4bf6dfe1803ca172a5ac41998839a5346d3de7dd127ea6a029206f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216e160255944c553d98fb04a373d35c5e4d73c57900cb43d30a2631b0a9cecb"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with :gcc do
    version "6"
    cause "Requires C++17 compatible compiler. See https:github.comfacebookrocksdbissues9388"
  end

  def install
    args = %W[
      -DPORTABLE=ON
      -DUSE_RTTI=ON
      -DWITH_BENCHMARK_TOOLS=OFF
      -DWITH_BZ2=ON
      -DWITH_LZ4=ON
      -DWITH_SNAPPY=ON
      -DWITH_ZLIB=ON
      -DWITH_ZSTD=ON
      -DROCKSDB_BUILD_SHARED=ON
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DZSTD_INCLUDE_DIRS=#{Formula["zstd"].include}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd "buildtools" do
      bin.install "sst_dump" => "rocksdb_sst_dump"
      bin.install "db_sanity_test" => "rocksdb_sanity_test"
      bin.install "write_stress" => "rocksdb_write_stress"
      bin.install "ldb" => "rocksdb_ldb"
      bin.install "db_repl_stress" => "rocksdb_repl_stress"
      bin.install "rocksdb_dump"
      bin.install "rocksdb_undump"
    end
    bin.install "builddb_stress_tooldb_stress" => "rocksdb_stress"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <assert.h>
      #include <rocksdboptions.h>
      #include <rocksdbmemtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        return 0;
      }
    EOS

    extra_args = []
    if OS.mac?
      extra_args << "-stdlib=libc++"
      extra_args << "-lstdc++"
    end
    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++17",
                                *extra_args,
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system ".db_test"

    assert_match "sst_dump --file=", shell_output("#{bin}rocksdb_sst_dump --help 2>&1")
    assert_match "rocksdb_sanity_test <path>", shell_output("#{bin}rocksdb_sanity_test --help 2>&1", 1)
    assert_match "rocksdb_stress [OPTIONS]...", shell_output("#{bin}rocksdb_stress --help 2>&1", 1)
    assert_match "rocksdb_write_stress [OPTIONS]...", shell_output("#{bin}rocksdb_write_stress --help 2>&1", 1)
    assert_match "ldb - RocksDB Tool", shell_output("#{bin}rocksdb_ldb --help 2>&1")
    assert_match "rocksdb_repl_stress:", shell_output("#{bin}rocksdb_repl_stress --help 2>&1", 1)
    assert_match "rocksdb_dump:", shell_output("#{bin}rocksdb_dump --help 2>&1", 1)
    assert_match "rocksdb_undump:", shell_output("#{bin}rocksdb_undump --help 2>&1", 1)

    db = testpath  "db"
    %w[no snappy zlib bzip2 lz4 zstd].each_with_index do |comp, idx|
      key = "key-#{idx}"
      value = "value-#{idx}"

      put_cmd = "#{bin}rocksdb_ldb put --db=#{db} --create_if_missing --compression_type=#{comp} #{key} #{value}"
      assert_equal "OK", shell_output(put_cmd).chomp

      get_cmd = "#{bin}rocksdb_ldb get --db=#{db} #{key}"
      assert_equal value, shell_output(get_cmd).chomp
    end
  end
end