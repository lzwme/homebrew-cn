class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https:rocksdb.org"
  url "https:github.comfacebookrocksdbarchiverefstagsv9.7.4.tar.gz"
  sha256 "9b810c81731835fda0d4bbdb51d3199d901fa4395733ab63752d297da84c5a47"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https:github.comfacebookrocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a00d2c563819c2d43c62a487f4e3260138d758b0119fad16219f13ecbaf17ebb"
    sha256 cellar: :any,                 arm64_sonoma:  "1ea138d47af1640c572e6ee76cb2a5284654bcdc1d6aca870ef6ee89624489b5"
    sha256 cellar: :any,                 arm64_ventura: "f8e762a7b9d6275d4e0e73e560876ca7932dad8cb64f9558ac394a0cd9076c29"
    sha256 cellar: :any,                 sonoma:        "862a66d02faff6e2a56a393c15ffa6d65b30d6f7d32378225632448fe4595305"
    sha256 cellar: :any,                 ventura:       "c31750e559962999928639c48d4f841e6fd53adae1ef8bd3877edabeab41979d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa4d9b3070ecd5b57ff98ddfc97898f70a39bbf4d9ec54eb82495c60005b38f"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
    (testpath"test.cpp").write <<~CPP
      #include <assert.h>
      #include <rocksdboptions.h>
      #include <rocksdbmemtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        return 0;
      }
    CPP

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

    db = testpath"db"
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