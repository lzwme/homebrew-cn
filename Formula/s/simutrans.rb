class Simutrans < Formula
  desc "Transport simulator"
  homepage "https:www.simutrans.com"
  url "svn:servers.simutrans.orgsimutranstrunk", revision: "11164"
  version "124.0"
  license "Artistic-1.0"
  revision 1
  head "https:github.comsimutranssimutrans.git", branch: "master"

  livecheck do
    url "https:sourceforge.netprojectssimutransfilessimutrans"
    regex(%r{href=.*?filessimutrans(\d+(?:[.-]\d+)+)}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5053e036752f688c1b43cd93dbe90e718e47f25b67d4d1495c8bd4414eaef7ea"
    sha256 cellar: :any,                 arm64_ventura:  "317f29c326ab735b90d3fe1bd8c82f04236819facb09d5a2a2c289b7ad70322e"
    sha256 cellar: :any,                 arm64_monterey: "fa53fdfd946870602a2ef85f02f72f290be3b0f797244912de49c4c43c66b2ab"
    sha256 cellar: :any,                 sonoma:         "cda8eb282092f90b3e9c65f7f2ab32d2bf43ee0c397345c81d862bab55145a99"
    sha256 cellar: :any,                 ventura:        "e56ae3b42719b33dad06b7ea683a9ac88f52a90c13b636379b63a1aae497b293"
    sha256 cellar: :any,                 monterey:       "1d2d5c36939c185fe6692998ae0701ccad393791b98d88380795bf19a562f368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4776aa464c1bf1fd76abd163f17737f00e8d1ab2b8323e96fcc80200da97a03"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "pak64" do
    url "https:downloads.sourceforge.netprojectsimutranspak64124-0simupak64-124-0.zip"
    sha256 "0defc5e7ce4c2c3620b621d94d0735dacc3ff13b1af24dee3a127ca76603b2a3"
  end
  resource "soundfont" do
    url "https:src.fedoraproject.orgrepopkgsPersonalCopy-Lite-soundfontPCLite.sf2629732b7552c12a8fae5b046d306273aPCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  def install
    # These translations are dynamically generated.
    system ".toolsget_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, "-DSIMUTRANS_USE_REVISION=#{version}"
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "makeobj"
    system "cmake", "--build", "build", "--target", "nettool"

    simutrans_path = OS.mac? ? "simutranssimutrans.appContentsMacOS" : "simutrans"
    libexec.install "build#{simutrans_path}simutrans" => "simutrans"
    libexec.install Dir["simutrans*"]
    bin.write_exec_script libexec"simutrans"
    bin.install "buildsrcmakeobjmakeobj"
    bin.install "buildsrcnettoolnettool"

    libexec.install resource("pak64")
    (libexec"music").install resource("soundfont")
  end

  test do
    system "#{bin}simutrans", "--help"
  end
end