class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://ghfast.top/https://github.com/facebook/rocksdb/archive/refs/tags/v10.7.5.tar.gz"
  sha256 "a9948bf5f00dd1e656fc40c4b0bf39001c3773ad22c56959bdb1c940d10e3d8d"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  revision 1
  head "https://github.com/facebook/rocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91f1e32cc2accef334886facbb0a87db6c5d64927e0c33a8a6d901d76775e8ca"
    sha256 cellar: :any,                 arm64_sequoia: "eac0fd5b81ce8bf4a25449cae9ddf7915860cd47bd6bfbf1faac9a3ac2e073b2"
    sha256 cellar: :any,                 arm64_sonoma:  "de2bb132a7d973e535390268a455be39ef3925b97b16c2ba86a96ea2d4e908c6"
    sha256 cellar: :any,                 sonoma:        "5e17d55dc11662f24138fa44b7d1c8e3ee6824abb6689457e189845b9a1a90df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66de4009ed5fb8249d79bd3305aca4391f03da4b3e1c82d9826e9958d8842cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f9289c81a27fa1291fa9f3fff08cf3d7fa8a4d212062e02bedd9beae4bb25f"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Fix to error ld: library 'atomic' not found
  # PR ref: https://github.com/facebook/rocksdb/pull/14048
  patch do
    url "https://github.com/facebook/rocksdb/commit/1d18c4ed0177f184f228a7cdfb78eb85d0dab540.patch?full_index=1"
    sha256 "7c76c3aaf970cd38129f42b6b76da3f37c59048507681c6953211d233e8cbdff"
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

    cd "build/tools" do
      bin.install "sst_dump" => "rocksdb_sst_dump"
      bin.install "db_sanity_test" => "rocksdb_sanity_test"
      bin.install "write_stress" => "rocksdb_write_stress"
      bin.install "ldb" => "rocksdb_ldb"
      bin.install "db_repl_stress" => "rocksdb_repl_stress"
      bin.install "rocksdb_dump"
      bin.install "rocksdb_undump"
    end
    bin.install "build/db_stress_tool/db_stress" => "rocksdb_stress"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
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
                                "-std=c++20",
                                *extra_args,
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./db_test"

    assert_match "sst_dump <db_dirs_OR_sst_files...>", shell_output("#{bin}/rocksdb_sst_dump --help 2>&1")
    assert_match "rocksdb_sanity_test <path>", shell_output("#{bin}/rocksdb_sanity_test --help 2>&1", 1)
    assert_match "rocksdb_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_stress --help 2>&1", 1)
    assert_match "rocksdb_write_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_write_stress --help 2>&1", 1)
    assert_match "ldb - RocksDB Tool", shell_output("#{bin}/rocksdb_ldb --help 2>&1")
    assert_match "rocksdb_repl_stress:", shell_output("#{bin}/rocksdb_repl_stress --help 2>&1", 1)
    assert_match "rocksdb_dump:", shell_output("#{bin}/rocksdb_dump --help 2>&1", 1)
    assert_match "rocksdb_undump:", shell_output("#{bin}/rocksdb_undump --help 2>&1", 1)

    db = testpath/"db"
    %w[no snappy zlib bzip2 lz4 zstd].each_with_index do |comp, idx|
      key = "key-#{idx}"
      value = "value-#{idx}"

      put_cmd = "#{bin}/rocksdb_ldb put --db=#{db} --create_if_missing --compression_type=#{comp} #{key} #{value}"
      assert_equal "OK", shell_output(put_cmd).chomp

      get_cmd = "#{bin}/rocksdb_ldb get --db=#{db} #{key}"
      assert_equal value, shell_output(get_cmd).chomp
    end
  end
end