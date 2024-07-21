class Simutrans < Formula
  desc "Transport simulator"
  homepage "https:www.simutrans.com"
  url "svn:servers.simutrans.orgsimutranstrunk", revision: "11351"
  version "124.2"
  license "Artistic-1.0"
  head "https:github.comsimutranssimutrans.git", branch: "master"

  livecheck do
    url "https:sourceforge.netprojectssimutransfilessimutrans"
    regex(%r{href=.*?filessimutrans(\d+(?:[.-]\d+)+)}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2fbd52dc6359452a145c821d73c066f37da4db93041892d26b9c793ab2a53c5"
    sha256 cellar: :any,                 arm64_ventura:  "b2be8ba9bdee787dcddd2fa3ced62ef0045033447d7d8bad6c83abbd309d0173"
    sha256 cellar: :any,                 arm64_monterey: "00e11775d858f4da3409305e6466b017bf70fbbe361d64a3ec273eab699ec0f9"
    sha256 cellar: :any,                 sonoma:         "5b63b20dabccc424807d9010893f0061785d563f8b392ecdfa3f05d1d0155670"
    sha256 cellar: :any,                 ventura:        "8c1246cd704450f903734f8453bd70a6e8f66f7e93c39b43bb810e9da408462a"
    sha256 cellar: :any,                 monterey:       "f1c54cb3e3fbe65542e2c474e62dfb3525c1686dc2b93ea7c6eaee7dbbc7fa89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd54e58b98c90f1a716fd2cfdcfd125807ace32396871b14dadf96f5e4164dc"
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
    system "#{bin}simutrans", "--help"
  end
end