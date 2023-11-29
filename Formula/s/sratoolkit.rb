class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://ghproxy.com/https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.9.tar.gz"
    sha256 "41159b817fb7649e42b41b3ca37bb3346d4fcb27049737d8a3bca5091ad74bb5"

    resource "ncbi-vdb" do
      url "https://ghproxy.com/https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.9.tar.gz"
      sha256 "26c94e5259b0c7e98fdaa1e93d41201df29ffff56946dd19464c6a0cfb584f92"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abf8b0714ee92a20c6cb79b7271b561dddff421248e39b04145fcefd18b4685a"
    sha256 cellar: :any,                 arm64_ventura:  "13600cd4bd449ceac9df26b9a3034af426cee8f5e68876b8a6b7dcd015823e91"
    sha256 cellar: :any,                 arm64_monterey: "c8eec70ee4795d3de7b262333d2d57d9308ed5990064415878def8e39fd2afb3"
    sha256 cellar: :any,                 sonoma:         "4e370bf623f5f6dc0cc10b84e0893104dd517b7ace91c76206c6cba4c4cf1c73"
    sha256 cellar: :any,                 ventura:        "b67c466dc5d2a1a24e26ac513cffea5e15c96b00cb304d3f65357468e3d3eb58"
    sha256 cellar: :any,                 monterey:       "645fe427c7bef779e28ba9c5dc20cd34dcc7c60203d59861c91d53595b5c57b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e275667ca8216cfe3002e0a8db46aff35070ec01ec358871f9358b4f520a0a1"
  end

  head do
    url "https://github.com/ncbi/sra-tools.git", branch: "master"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on macos: :catalina

  uses_from_macos "libxml2"

  def install
    (buildpath/"ncbi-vdb-source").install resource("ncbi-vdb")

    # Workaround to allow clang/aarch64 build to use the gcc/arm64 directory
    # Issue ref: https://github.com/ncbi/ncbi-vdb/issues/65
    ln_s "../gcc/arm64", buildpath/"ncbi-vdb-source/interfaces/cc/clang/arm64" if Hardware::CPU.arm?

    # Need to use HDF 1.10 API: error: too few arguments to function call, expected 5, have 4
    # herr_t h5e = H5Oget_info_by_name( self->hdf5_handle, buffer, &obj_info, H5P_DEFAULT );
    ENV.append_to_cflags "-DH5_USE_110_API"

    system "cmake", "-S", "ncbi-vdb-source", "-B", "ncbi-vdb-build", *std_cmake_args,
                    "-DNGS_INCDIR=#{buildpath}/ngs/ngs-sdk"
    system "cmake", "--build", "ncbi-vdb-build"

    system "cmake", "-S", ".", "-B", "sra-tools-build", *std_cmake_args,
                    "-DVDB_BINDIR=#{buildpath}/ncbi-vdb-build",
                    "-DVDB_LIBDIR=#{buildpath}/ncbi-vdb-build/lib",
                    "-DVDB_INCDIR=#{buildpath}/ncbi-vdb-source/interfaces"
    system "cmake", "--build", "sra-tools-build"
    system "cmake", "--install", "sra-tools-build"

    # Remove non-executable files.
    (bin/"ncbi").rmtree
  end

  test do
    assert_equal version, resource("ncbi-vdb").version, "`ncbi-vdb` resource needs updating!" if build.stable?

    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https://github.com/ncbi/sra-tools/issues/291
    require "securerandom"
    mkdir ".ncbi"
    (testpath/".ncbi/user-settings.mkfg").write "/LIBS/GUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end