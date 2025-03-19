class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https:github.comncbisra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https:github.comncbisra-toolsarchiverefstags3.2.1.tar.gz"
    sha256 "2558683c217ad2318833ab7731939617ed91dc79a6b1dee92bf88b56a1dc142a"

    resource "ncbi-vdb" do
      url "https:github.comncbincbi-vdbarchiverefstags3.2.1.tar.gz"
      sha256 "535511984928ec5bac02a61fc6b4d1ca72a5b69c742f4882eabd32ed3a97621c"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f638492e68e21c284a4aeee221d5e169b1984a75adf1648fa33d8481dd354f9"
    sha256 cellar: :any,                 arm64_sonoma:  "5eb9c8506a1ad99e5f5b929314e807018e7e0ad2562cee2bfe55f6fe3a9f49f7"
    sha256 cellar: :any,                 arm64_ventura: "111636d770e9da3b1b0cd652f0cb46b7fb48e283e553859fb04aebc6078d7b3f"
    sha256 cellar: :any,                 sonoma:        "f6b0a3c7e7ea88755d2cb2f33a58c8b93565f8ed8024f9b3a3709425775cbe8b"
    sha256 cellar: :any,                 ventura:       "4d6f5a48ea2ce178703d4ec93bbaa589a3e3c86751a9a8eaf95dd6faac75590a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580d70086da44a3bab3152314fe4af79a710f04dc140bb032c13ee26b5323211"
  end

  head do
    url "https:github.comncbisra-tools.git", branch: "master"

    resource "ncbi-vdb" do
      url "https:github.comncbincbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on macos: :catalina

  uses_from_macos "libxml2"

  def install
    odie "ncbi-vdb resource needs to be updated" if build.stable? && version != resource("ncbi-vdb").version

    (buildpath"ncbi-vdb-source").install resource("ncbi-vdb")

    # Need to use HDF 1.10 API: error: too few arguments to function call, expected 5, have 4
    # herr_t h5e = H5Oget_info_by_name( self->hdf5_handle, buffer, &obj_info, H5P_DEFAULT );
    ENV.append_to_cflags "-DH5_USE_110_API"

    system "cmake", "-S", "ncbi-vdb-source", "-B", "ncbi-vdb-build", *std_cmake_args,
                    "-DNGS_INCDIR=#{buildpath}ngsngs-sdk"
    system "cmake", "--build", "ncbi-vdb-build"

    system "cmake", "-S", ".", "-B", "sra-tools-build", *std_cmake_args,
                    "-DVDB_BINDIR=#{buildpath}ncbi-vdb-build",
                    "-DVDB_LIBDIR=#{buildpath}ncbi-vdb-buildlib",
                    "-DVDB_INCDIR=#{buildpath}ncbi-vdb-sourceinterfaces"
    system "cmake", "--build", "sra-tools-build"
    system "cmake", "--install", "sra-tools-build"

    # Remove non-executable files.
    rm_r(bin"ncbi")
  end

  test do
    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https:github.comncbisra-toolsissues291
    require "securerandom"
    mkdir ".ncbi"
    (testpath".ncbiuser-settings.mkfg").write "LIBSGUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end