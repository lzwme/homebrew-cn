class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https:nco.sourceforge.net"
  url "https:github.comnconcoarchiverefstags5.1.9.tar.gz"
  sha256 "9cd90345c1e3860a690b53fd6c08b721d631a646d169431927884c99841c34e9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb15500151c5d2e34915623aae8295aec91ea693fa0d8124581bd7059e99f63a"
    sha256 cellar: :any,                 arm64_ventura:  "aef8e520e579d650a23f9789f7354abb32f687579588d5d6538f0d8f3362d6c8"
    sha256 cellar: :any,                 arm64_monterey: "0561b9a65269e8a773cb215a1afb88bbade100b9763b7a30911acf8e09ee45b3"
    sha256 cellar: :any,                 sonoma:         "416b332e1d68d15db81c6e31616d75d3f02f2cd518ff8d62ccd663ebf3d54a0a"
    sha256 cellar: :any,                 ventura:        "ab0827f308ae99e56759ee87ec8ccd63a1a1519c1642514392505caf0c642dcd"
    sha256 cellar: :any,                 monterey:       "9515af06a5567c884c23f7a9a6948d0258cc403f94e79e607c16579f04a5bd5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5326e9502690bb85790125af28c794a82233b36962dfeb9cfe264fd2b8bfcdce"
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