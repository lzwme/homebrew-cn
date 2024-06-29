class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https:rocksdb.org"
  url "https:github.comfacebookrocksdbarchiverefstagsv9.3.1.tar.gz"
  sha256 "e63f1be162998c0f49a538a7fe3fcac0e40cad77ee47d5592a65bca50f7c4620"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https:github.comfacebookrocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3250827b3a578ad7d4c91f10a6ff83c3d45e0f8ca33121c127dd954827c43f1b"
    sha256 cellar: :any,                 arm64_ventura:  "8432f8c874d7233fa1f494a73a92ea289698017749fe658f0bf179123f5c8ad1"
    sha256 cellar: :any,                 arm64_monterey: "a64f92cbe55fc4c1c1ee8707df76994689eab73fa4b47e55e54d1493df2e1fa4"
    sha256 cellar: :any,                 sonoma:         "3945f21fe019f8c55171bb61082159b85304d91609d19afc4a0321e2073ff94f"
    sha256 cellar: :any,                 ventura:        "c992e7cd23f02a39e0b784652f059251ef3c50df799a84f44a766577171a438a"
    sha256 cellar: :any,                 monterey:       "c19e70bad2d6c4871d90e98e0309db4264743130797d8f6364294a6f880cc2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ee3a586cc10861e10e7daa25bc270a0ed4ce5cf47eb61b5f45619df9669fb8"
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