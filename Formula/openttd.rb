class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/13.2/openttd-13.2-source.tar.xz"
  sha256 "c5fe48b802a34b7181855b414070b82b388a636bf0c526b0040c3c88ce263d6f"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url "https://cdn.openttd.org/openttd-releases/latest.yaml"
    regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9fef3c85377dd88226630292cdc9f7f3c7d33f48eec62e917d63c13369abc467"
    sha256 cellar: :any, arm64_monterey: "9da56f687042b466a9f272d776dda4aed4796eda6971a962d31599800b70fb05"
    sha256 cellar: :any, arm64_big_sur:  "1a655ed10039029a15c557d8142832d2e9606b53561b575b9bf7262e5e1cd237"
    sha256 cellar: :any, ventura:        "0ac97c8b16c23509176556e4128569ca3d6e322171bc2f85d943d0ca9b9dec0e"
    sha256 cellar: :any, monterey:       "fcbd3482d52c067561ead48f35030953ba774a52848845e201b781e23c5eda17"
    sha256 cellar: :any, big_sur:        "3dc9094460e06016f4ab6e768e87f523220a4418d8e1adc8094bc3edc9a9d0fe"
    sha256               x86_64_linux:   "6a726f032832c4adb49b1787ffeed0c5a79dfd77443ee6e69614eff9961634b2"
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