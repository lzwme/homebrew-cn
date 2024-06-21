class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https:nco.sourceforge.net"
  url "https:github.comnconcoarchiverefstags5.2.6.tar.gz"
  sha256 "31245c56c031eee14e32d77b56fcc291785e407ed9534a62c2f1f8320eb317af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ec609abef5e462c5c0541bd769a2ce0317d693c1b40d92840da17996d09086c7"
    sha256 cellar: :any,                 arm64_ventura:  "8e87da1aaf3b8890a793984f75ee674b57a9682f18b5e57881cd99f7e721e255"
    sha256 cellar: :any,                 arm64_monterey: "d7bd02c99636da294a5524e75d014a2e4c952a6f2a4e62345b1ef7e42b0f65d7"
    sha256 cellar: :any,                 sonoma:         "46d375cb4dc99b9f201d99952fe5274acd570212a2fcb5fcbc9078f85d7252bd"
    sha256 cellar: :any,                 ventura:        "7746805776783d01e05ad0d8bd4842825ba8c8d3043b96ae608f237d74c57bb6"
    sha256 cellar: :any,                 monterey:       "512040ee8c32bf0098bf7a8d1604c96eee77d47fc72072a310cf4b027c3d6b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa4b0317d3b497a7a0922084effa81c49535a697643f7be5bc4656143bbda47"
  end

  head do
    url "https:github.comnconco.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openjdk" => :build # needed for antlr2
  depends_on "gettext"
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  uses_from_macos "flex" => :build

  resource "antlr2" do
    url "https:github.comncoantlr2archiverefstagsantlr2-2.7.7-1.tar.gz"
    sha256 "d06e0ae7a0380c806321045d045ccacac92071f0f843aeef7bdf5841d330a989"
  end

  def install
    resource("antlr2").stage do
      system ".configure", "--prefix=#{buildpath}",
                            "--disable-debug",
                            "--disable-csharp"
      system "make"

      (buildpath"libexec").install "antlr.jar"
      (buildpath"include").install "libcppantlr"
      (buildpath"lib").install "libcppsrclibantlr.a"

      (buildpath"binantlr").write <<~EOS
        #!binsh
        exec "#{Formula["openjdk"].opt_bin}java" -classpath "#{buildpath}libexecantlr.jar" antlr.Tool "$@"
      EOS

      chmod 0755, buildpath"binantlr"
    end

    ENV.append "CPPFLAGS", "-I#{buildpath}include"
    ENV.append "LDFLAGS", "-L#{buildpath}lib"
    ENV.prepend_path "PATH", buildpath"bin"
    system ".autogen.sh" if build.head?
    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    resource "homebrew-example_nc" do
      url "https:www.unidata.ucar.edusoftwarenetcdfexamplesWMI_Lear.nc"
      sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
    end

    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end