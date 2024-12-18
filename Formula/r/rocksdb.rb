class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https:rocksdb.org"
  url "https:github.comfacebookrocksdbarchiverefstagsv9.9.3.tar.gz"
  sha256 "126c8409e98a3acea57446fb17faf22767f8ac763a4516288dd7c05422e33df2"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https:github.comfacebookrocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7adc8a690b19bb7d14cbfc2168fb92a250275c44f44669d9a3c744ad7144297"
    sha256 cellar: :any,                 arm64_sonoma:  "72c890910bff4a9f7f992fbe71289be5b99d7285dcc54bab3b24f0d4f56f475f"
    sha256 cellar: :any,                 arm64_ventura: "f1bf3fc449ad0104ed50ad1d56fb2f4a6310e9ed3536e5028d480174e76c6534"
    sha256 cellar: :any,                 sonoma:        "fb6a733bafb4953dc5cf56ef7b97f85e00c17b95ec89304728b3e8ef863bb1ab"
    sha256 cellar: :any,                 ventura:       "8ca402e1652e66d63e293d2cdec5734e1e2b978798860f537ab2a019ea70dde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "154cdd295664f1642d51c75128676201f48c0b6f9b2d73c67682664f1f7f704c"
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