class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https:nco.sourceforge.net"
  url "https:github.comnconcoarchiverefstags5.2.3.tar.gz"
  sha256 "178ad32448067c72dc82b71ffc8b39add1252637cf6f9e23982ba1484920ca44"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca8fedc2e92e33a65a1942b37a5e8c00bba9830cf17040aa74f88985dba9d168"
    sha256 cellar: :any,                 arm64_ventura:  "504607d49f1014d57f6c81b884e4d1bd255a66b42f9d0faac2a8fcecf328a81c"
    sha256 cellar: :any,                 arm64_monterey: "8f44e78f0158acec9e218003a4f92dcd3c5e550cd32e93407774d8cccc91eb2a"
    sha256 cellar: :any,                 sonoma:         "541354bca7d8cce4e966a134704a1d667b58fa5a84ed258ea843754a9e9811af"
    sha256 cellar: :any,                 ventura:        "4f2c360286017b8bd0e9d865588ff06329e960c68848ea72df652bc669764c39"
    sha256 cellar: :any,                 monterey:       "9a8613d2c98634b346b56d4efa12196e1cc1ec493c7eeda30561d7fa676cd7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c276ce9e59d0cf463c7d6d067da0ee9a7d9ed1d43a83a17cdcf68afcab94cda"
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