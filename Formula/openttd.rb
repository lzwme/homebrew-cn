class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/13.2.1/openttd-13.2.1-source.tar.xz"
  sha256 "baa4b39ad0158bd13f6aee472667a0fbf655c7576d4f8d18b1005c8ffa866576"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url "https://cdn.openttd.org/openttd-releases/latest.yaml"
    regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "549b3fd036d23c843837d020c65b824c82e4fc378a40d72a13e4e46a350c37ab"
    sha256 cellar: :any, arm64_monterey: "01aee9d1820d21fbeb7603fb6d2af6116921716a2b5605bdc22141dd9145918b"
    sha256 cellar: :any, arm64_big_sur:  "85e9c7fd428cee304ca596c7a5806630938f73be6d63b8c3226ebcd1287f62e7"
    sha256 cellar: :any, ventura:        "16d1521b7b4ceedfbc8b4aefb3e3491194c657942a356cdb344e97fdc4ae4242"
    sha256 cellar: :any, monterey:       "717887148160f502a92b20a4222aac36aa05a0732d95ef9a593895bdabf46616"
    sha256 cellar: :any, big_sur:        "d87e92c04a83810f42166b5ade9f37d0ab08d68877e43da6226d24fa7984ea44"
    sha256               x86_64_linux:   "855e9f842f186bf7bd33fc7a9add89b80787b258585be2b25fa9e815d1dd08c2"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :high_sierra # needs C++17
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "fluid-synth"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "icu4c"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "sdl2"
  end

  fails_with gcc: "5"

  resource "opengfx" do
    url "https://cdn.openttd.org/opengfx-releases/7.1/opengfx-7.1-all.zip"
    sha256 "928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846"

    livecheck do
      url "https://cdn.openttd.org/opengfx-releases/latest.yaml"
      regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.2/openmsx-0.4.2-all.zip"
    sha256 "5a4277a2e62d87f2952ea5020dc20fb2f6ffafdccf9913fbf35ad45ee30ec762"

    livecheck do
      url "https://cdn.openttd.org/openmsx-releases/latest.yaml"
      regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.3/opensfx-1.0.3-all.zip"
    sha256 "e0a218b7dd9438e701503b0f84c25a97c1c11b7c2f025323fb19d6db16ef3759"

    livecheck do
      url "https://cdn.openttd.org/opensfx-releases/latest.yaml"
      regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs
    inreplace "cmake/PackageBundle.cmake", "fixup_bundle(", "# \\0"

    args = std_cmake_args
    unless OS.mac?
      args << "-DCMAKE_INSTALL_BINDIR=bin"
      args << "-DCMAKE_INSTALL_DATADIR=#{share}"
    end

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    if OS.mac?
      cd "build" do
        system "cpack || :"
      end
    else
      system "cmake", "--install", "build"
    end

    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    app = "build/_CPack_Packages/#{arch}/Bundle/openttd-#{version}-macos-#{arch}/OpenTTD.app"
    resources.each do |r|
      if OS.mac?
        (buildpath/"#{app}/Contents/Resources/baseset/#{r.name}").install r
      else
        (share/"openttd/baseset"/r.name).install r
      end
    end

    if OS.mac?
      prefix.install app
      bin.write_exec_script "#{prefix}/OpenTTD.app/Contents/MacOS/openttd"
    end
  end

  test do
    assert_match "OpenTTD #{version}\n", shell_output("#{bin}/openttd -h")
  end
end