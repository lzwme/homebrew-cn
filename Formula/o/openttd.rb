class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https:www.openttd.org"
  url "https:cdn.openttd.orgopenttd-releases14.1openttd-14.1-source.tar.xz"
  sha256 "2c14c8f01f44148c4f2c88c169a30abcdb002eb128a92b9adb76baa76b013494"
  license "GPL-2.0-only"
  head "https:github.comOpenTTDOpenTTD.git", branch: "master"

  livecheck do
    url "https:cdn.openttd.orgopenttd-releaseslatest.yaml"
    strategy :yaml do |yaml|
      yaml["latest"]&.map do |item|
        next if item["name"] != "stable"

        item["version"]&.to_s
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "9bf761325d3daef0e00c49a0342f01c6644eeb8e02e4e5ea2a0e97ff9e082bb3"
    sha256 cellar: :any, arm64_sonoma:  "ae5d3950fa4f5657138cb1065b1cdbabb002e45bb477c36043b222337309adba"
    sha256 cellar: :any, arm64_ventura: "96fc8bd75124c582c395b096510ac5a5181011324e864245405868b986e5c98a"
    sha256 cellar: :any, sonoma:        "21fe8f3bdf5dc3a72cb9611b803ded25636c2810011e92473ea746e8a408aa47"
    sha256 cellar: :any, ventura:       "ec77cc4c95af77799c2633ad0a923407d1bdc41b1f01f64c19c02e49fa4474a1"
    sha256               x86_64_linux:  "3f9df17a1ca7f18ea2c30b5de7c02658d9dee44dbdf1561d34c9c58fe6043906"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :catalina # needs C++20
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "fluid-synth"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "mesa" # no linkage as dynamically loaded by SDL2
    depends_on "sdl2"
  end

  fails_with gcc: "5"

  resource "opengfx" do
    url "https:cdn.openttd.orgopengfx-releases7.1opengfx-7.1-all.zip"
    sha256 "928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846"

    livecheck do
      url "https:cdn.openttd.orgopengfx-releaseslatest.yaml"
      strategy :yaml do |yaml|
        yaml["latest"]&.map do |item|
          next if item["name"] != "stable"

          item["version"]&.to_s
        end
      end
    end
  end

  resource "openmsx" do
    url "https:cdn.openttd.orgopenmsx-releases0.4.2openmsx-0.4.2-all.zip"
    sha256 "5a4277a2e62d87f2952ea5020dc20fb2f6ffafdccf9913fbf35ad45ee30ec762"

    livecheck do
      url "https:cdn.openttd.orgopenmsx-releaseslatest.yaml"
      strategy :yaml do |yaml|
        yaml["latest"]&.map do |item|
          next if item["name"] != "stable"

          item["version"]&.to_s
        end
      end
    end
  end

  resource "opensfx" do
    url "https:cdn.openttd.orgopensfx-releases1.0.3opensfx-1.0.3-all.zip"
    sha256 "e0a218b7dd9438e701503b0f84c25a97c1c11b7c2f025323fb19d6db16ef3759"

    livecheck do
      url "https:cdn.openttd.orgopensfx-releaseslatest.yaml"
      strategy :yaml do |yaml|
        yaml["latest"]&.map do |item|
          next if item["name"] != "stable"

          item["version"]&.to_s
        end
      end
    end
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs
    inreplace "cmakePackageBundle.cmake", "fixup_bundle(", "# \\0"
    # Have CMake use our FIND_FRAMEWORK setting
    inreplace "CMakeLists.txt", "set(CMAKE_FIND_FRAMEWORK LAST)", ""

    args = std_cmake_args(find_framework: "FIRST")
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
    app = "build_CPack_Packages#{arch}Bundleopenttd-#{version}-macos-#{arch}OpenTTD.app"
    resources.each do |r|
      if OS.mac?
        (buildpath"#{app}ContentsResourcesbaseset#{r.name}").install r
      else
        (pkgshare"baseset"r.name).install r
      end
    end

    if OS.mac?
      prefix.install app
      bin.write_exec_script "#{prefix}OpenTTD.appContentsMacOSopenttd"
    end
  end

  test do
    assert_match "OpenTTD #{version}\n", shell_output("#{bin}openttd -h")
  end
end