class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https:rocksdb.org"
  url "https:github.comfacebookrocksdbarchiverefstagsv9.5.2.tar.gz"
  sha256 "b20780586d3df4a3c5bcbde341a2c1946b03d18237960bda5bc5e9538f42af40"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https:github.comfacebookrocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ac670f22bfaf32815f546a35a222a485a312a13d1ab3f6d4f888d6e4f14cf54"
    sha256 cellar: :any,                 arm64_ventura:  "291a6fa0702509962eb29a3461cb2568af03a2615b8c11bf83f2985385157886"
    sha256 cellar: :any,                 arm64_monterey: "e494f538d2b282fc489ee06f97db6cdf38ca7e99ba5ba67715ae5476b4505313"
    sha256 cellar: :any,                 sonoma:         "689dd8ce1788161b7c6a9e8cb2590a267b3ee96a95e8b179b81aee5e3caffd72"
    sha256 cellar: :any,                 ventura:        "ecc9320177a255d5441f1b0de72c473eee57ac986661059c5aa7c4ebfc14f237"
    sha256 cellar: :any,                 monterey:       "f3f6a20e2fdbeb7f3b430223ad7674c20bfd5f48f27b4fb447abe3f3345f2245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622ed36e532e2a6d45671f4a8d1cbc520f7c755e25806d1bd2e16c1ffd056fb4"
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