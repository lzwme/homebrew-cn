class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https:nco.sourceforge.net"
  url "https:github.comnconcoarchiverefstags5.3.0.tar.gz"
  sha256 "661d12f4eb678ca301bf6000f1c1d0fb0e32a69def237dc14f3253e9fc1aaf6a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c9c38bb4dda815909d103da84dce502aa8cadddbc7df188c86a3ac2c7db2637"
    sha256 cellar: :any,                 arm64_sonoma:  "3132a8ec83a442ccb0718afe046684cfe10474aed7a96bc70a20307ea0cad85c"
    sha256 cellar: :any,                 arm64_ventura: "70f56a4234af5feef1975a19a830c9b01571c072a4109e24774eac0c78c7f50e"
    sha256 cellar: :any,                 sonoma:        "79806516c40d58a0a6b6602faa81e707b80f46817676cd29113193fb4eac92c8"
    sha256 cellar: :any,                 ventura:       "51fc29e80898d8414db875113a2f8b29e91233303d22e163536acc3b7c663198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6dbe757dbf4ad0952f31987c0a5fcf2606cb475db5e5aa73daa4bf8fc423774"
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

      (buildpath"binantlr").write <<~SH
        #!binsh
        exec "#{Formula["openjdk"].opt_bin}java" -classpath "#{buildpath}libexecantlr.jar" antlr.Tool "$@"
      SH

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