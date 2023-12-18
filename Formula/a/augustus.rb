class Augustus < Formula
  desc "Predict genes in eukaryotic genomic sequences"
  homepage "https:bioinf.uni-greifswald.deaugustus"
  url "https:github.comGaius-AugustusAugustusarchiverefstagsv3.5.0.tar.gz"
  sha256 "5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686"
  license "Artistic-1.0"
  revision 4
  head "https:github.comGaius-AugustusAugustus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96eb031e7b4234ca518c57baf5111f7baef58fb213b046475f9406ce8cf404df"
    sha256 cellar: :any,                 arm64_ventura:  "5a8eb711d5e9e5f486a8c0e6738e8ec7f37b856946caebb34ccce19f103b8751"
    sha256 cellar: :any,                 arm64_monterey: "4af9181736c6cce96f2546e13b48bd6043242837f491ba25830a9f8b7081ee09"
    sha256 cellar: :any,                 sonoma:         "27cc557ee849b2f88303bb2c9419de6bc603452c308846eda1e57fc34d9d1636"
    sha256 cellar: :any,                 ventura:        "9f851d87aa6b52dc8c39e6816dd2592ac7d6fca21c347a19427b4eefae184469"
    sha256 cellar: :any,                 monterey:       "bb2c84661c7be38aa1fa4367c3daf51c020855f26c2e60c6b809c698c83c32c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9d744d2f9c0c9ae1ebbf72ffce804e7f1bf8c6c66ae205ff0f92ff30957d2be"
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "htslib"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  def install
    # Compile executables for macOS. Tarball ships with executables for Linux.
    system "make", "clean"

    system "make", "COMPGENEPRED=false",
                   "INCLUDE_PATH_BAMTOOLS=-I#{Formula["bamtools"].opt_include}bamtools",
                   "LIBRARY_PATH_BAMTOOLS=-L#{Formula["bamtools"].opt_lib}",
                   "INCLUDE_PATH_HTSLIB=-I#{Formula["htslib"].opt_include}htslib",
                   "LIBRARY_PATH_HTSLIB=-L#{Formula["htslib"].opt_lib}"

    # Set PREFIX to prevent symlinking into usrlocalbin
    (buildpath"tmpbin").mkpath
    system "make", "install", "INSTALLDIR=#{prefix}", "PREFIX=#{buildpath}tmp"

    bin.env_script_all_files libexec"bin", AUGUSTUS_CONFIG_PATH: prefix"config"
    pkgshare.install "examples"
  end

  test do
    (testpath"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}augustus --species=human test.fasta"
    assert_match "Predicted genes", shell_output(cmd)

    cp pkgshare"examplesexample.fa", testpath
    cp pkgshare"examplesprofileHsDHC.prfl", testpath
    cmd = "#{bin}augustus --species=human --proteinprofile=HsDHC.prfl example.fa 2> devnull"
    assert_match "HS04636	AUGUSTUS	gene	966	6903	1	+	.	g1", shell_output(cmd)
  end
end