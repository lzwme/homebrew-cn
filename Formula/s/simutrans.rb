class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "12321"
  version "125.0"
  license "Artistic-1.0"
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("-", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "48a17f38b1791aab60304da5318b03bd55e1ffb373c2f0da40efebdf42d93598"
    sha256 cellar: :any, arm64_tahoe:       "fdae87b232ee8df110b6d374f134767124448b7fa858f9d241441b2081a1d8bd"
    sha256 cellar: :any, arm64_sequoia:     "2ff427aad67e5cd32574d3e544fc7268cadfc243bfcaee99eb65460d26e725da"
    sha256 cellar: :any, arm64_linux:       "fcc909f211b3c578907c4b14b16ae67713617aec813a867f065fdc38ad67a58b"
    sha256 cellar: :any, x86_64_linux:      "d6ce9e4900c6bbd3f30a928cc4f99d7d09b85fb6a95f9d871d6c6d7e23509a7e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "miniupnpc"
  depends_on "sdl2-compat"
  depends_on "zstd"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-4/simupak64-124-4.zip"
    sha256 "edc6f9ca8d94af7bfcc9628ce1e7ddf468b07118cde0a50a8b5d0d30c22218ee"
  end
  resource "soundfont" do
    url "https://src.fedoraproject.org/repo/pkgs/PersonalCopy-Lite-soundfont/PCLite.sf2/629732b7552c12a8fae5b046d306273a/PCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  # Translations are downloaded during `build` phase
  allow_network_access! :build

  def install
    # These translations are dynamically generated.
    system "./tools/get_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", "-DSIMUTRANS_USE_REVISION=#{stable.specs[:revision]}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "makeobj"
    system "cmake", "--build", "build", "--target", "nettool"

    simutrans_path = OS.mac? ? "simutrans/simutrans.app/Contents/MacOS" : "simutrans"
    libexec.install "build/#{simutrans_path}/simutrans" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "build/src/makeobj/makeobj"
    bin.install "build/src/nettool/nettool"

    libexec.install resource("pak64")
    (libexec/"music").install resource("soundfont")
  end

  test do
    system bin/"simutrans", "--help"
  end
end