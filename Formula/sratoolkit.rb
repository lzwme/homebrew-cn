class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]
  revision 1

  stable do
    url "https://ghproxy.com/https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.3.tar.gz"
    sha256 "ea4b9a4b2e6e40e6b2bf36b01eb8df2b50280ef9dcdc66b504c1d1296600afbd"

    resource "ncbi-vdb" do
      url "https://ghproxy.com/https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.2.tar.gz"
      sha256 "275ccb225ddb156688c8c71f772f73276cb18ebff773a51150f86f8002ed2d59"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "306a5aa250bdc3964d159c523a81e5c8889b2d5540b324c677203b1b99f510ba"
    sha256 cellar: :any,                 arm64_monterey: "202ab27c9d14527965f8a57f37c03750de0ad35e68a32a4a5a101184d1794dfd"
    sha256 cellar: :any,                 arm64_big_sur:  "a91e8171d1874951f60bd35d11eb51a1e761de3b2ae4653ad53529cb8c05f2c4"
    sha256 cellar: :any,                 ventura:        "6dbdefb6628b9bc40345f93b458de414c7a943f4fda964a6f357a27531d74ea3"
    sha256 cellar: :any,                 monterey:       "4802087d65391b3de4ccc2f9fc067a7ac640d817d6c22754f7faf231b3fa8bfd"
    sha256 cellar: :any,                 big_sur:        "af18107726ebbbb23daa9d937176212e96d5911da3d9055855feb5f1ba0d8769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fe53f93b4663a16530128c410a8b2b65fd54ab1ddf049b3d2ef122530546906"
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
    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https://github.com/ncbi/sra-tools/issues/291
    require "securerandom"
    mkdir ".ncbi"
    (testpath/".ncbi/user-settings.mkfg").write "/LIBS/GUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end