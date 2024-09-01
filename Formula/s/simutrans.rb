class Simutrans < Formula
  desc "Transport simulator"
  homepage "https:www.simutrans.com"
  url "svn:servers.simutrans.orgsimutranstrunk", revision: "11395"
  version "124.2.2"
  license "Artistic-1.0"
  head "https:github.comsimutranssimutrans.git", branch: "master"

  livecheck do
    url "https:sourceforge.netprojectssimutransfilessimutrans"
    regex(%r{href=.*?filessimutrans(\d+(?:[.-]\d+)+)}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d8bf26755e48c6addf9c56f74663a94d128ebf8530e907723d3f3d72563d816"
    sha256 cellar: :any,                 arm64_ventura:  "ebeae515fdeb4f36b8f740ddf97fd8a0b6fd7be92b15279aadfb6c828c88d244"
    sha256 cellar: :any,                 arm64_monterey: "111bc78c6b12fa85f08c07ffb88bdaebb09d2c661180a62192d5eade9395258d"
    sha256 cellar: :any,                 sonoma:         "4e9865cec3ae3a7657c8fc376741a33e23cbd8f0def9f45be5c7c382f0842cd3"
    sha256 cellar: :any,                 ventura:        "7ee56eef736b595d9386c129400bb38269968e82cdf7067820e2fed8dc175970"
    sha256 cellar: :any,                 monterey:       "c32336285edb2c0e538350536578b89592d32fac030be677eb527af58c002bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faee3e5fa566c1daef3d91393bcc8761dfc182f6e3e50c8cc2b2f5685fecb907"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "pak64" do
    url "https:downloads.sourceforge.netprojectsimutranspak64124-2simupak64-124-2.zip"
    sha256 "e690e4647a1a617032a3778a2457c8812cc4510afad0f5bf8524999468146d86"
  end
  resource "soundfont" do
    url "https:src.fedoraproject.orgrepopkgsPersonalCopy-Lite-soundfontPCLite.sf2629732b7552c12a8fae5b046d306273aPCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  def install
    # These translations are dynamically generated.
    system ".toolsget_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, "-DSIMUTRANS_USE_REVISION=#{stable.specs[:revision]}"
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
    system bin"simutrans", "--help"
  end
end