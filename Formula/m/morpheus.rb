class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.3.9/morpheus-v2.3.9.tar.gz"
  sha256 "d27b7c2b5ecf503fd11777b3a75d4658a6926bfd9ae78ef97abf5e9540a6fb29"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "7e26be19e1ae33a04c2183277b10136d26261ea2bcf2af177d13fd32ec8bd0ea"
    sha256                               arm64_sequoia: "4020aba25f72c7c1994268abd7a51d625b3c4d03bba900d58bad3fb7c41f18ff"
    sha256                               arm64_sonoma:  "6d7ecede2635239fcc44cc2e6db21d8d819f1b4855898115548916fdbefc6010"
    sha256                               arm64_ventura: "e30b659545e485356790d7938d5a4af5570584315b9272ca03b7aee3b4219160"
    sha256 cellar: :any,                 sonoma:        "256731739687f46cf2509eb9a3e5f0c7139dea775ce5f8e450b855ef910ac703"
    sha256 cellar: :any,                 ventura:       "00fdbd8f0594d9daca951726618c1275396758a60aac129dc85451af78a7657e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d216e4cd5fcec17db0a326688795f2ee4e3517379b79b3f94ef0f53a0f56ee3"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "ffmpeg"
  depends_on "graphviz"
  depends_on "libtiff"
  depends_on "qt@5"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # Backport support for CMake 4
  patch do
    url "https://gitlab.com/morpheus.lab/morpheus/-/commit/74aa906b9c2bd9144776118e61ffef3220a70878.diff"
    sha256 "7d186bcd41b640e770f592053f25a4216c57ae56e5ecee68f271e8d00fbfa4a1"
  end
  patch do
    url "https://gitlab.com/morpheus.lab/morpheus/-/commit/aac15ea4e196083a00c0634d1aaa6d49875721c7.diff"
    sha256 "2e6f40b7acf4b81643b5af411f1e6bb8d7bc01282a638488c8be41fbdbb68675"
  end
  patch do
    url "https://gitlab.com/morpheus.lab/morpheus/-/commit/8c5035ef693068a1ddcfdc710f45bd4f4663ee8b.diff"
    sha256 "e0916157e4c32c7370f3b0a140b43c4a30c2173c9a65e73c2dd6a817011920ed"
  end

  def install
    # Avoid statically linking to Boost libraries when `-DBUILD_TESTING=OFF`
    cmakelists = ["CMakeLists.txt", "morpheus/CMakeLists.txt"]
    inreplace cmakelists, "set(Boost_USE_STATIC_LIBS ON)", "set(Boost_USE_STATIC_LIBS OFF)"

    # Workaround for newer Clang
    # error: a template argument list is expected after a name prefixed by the template keyword
    ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw" if OS.mac?

    # has to build with Ninja until: https://gitlab.kitware.com/cmake/cmake/-/issues/25142
    args = ["-G", "Ninja"]

    if OS.mac?
      args << "-DMORPHEUS_RELEASE_BUNDLE=ON"
      args << "-DBREW_FORMULA_DEPLOYMENT=ON"
      args << "-DMORPHEUS_SBML=OFF" # SBML import currently disabled due to libSBML build errors with some macOS SDKs
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    bin.write_exec_script "#{prefix}/Morpheus.app/Contents/MacOS/morpheus"
    bin.write_exec_script "#{prefix}/Morpheus.app/Contents/MacOS/morpheus-gui"

    # Set PATH environment variable including Homebrew prefix in macOS app bundle
    inreplace "#{prefix}/Morpheus.app/Contents/Info.plist", "HOMEBREW_BIN_PATH", "#{HOMEBREW_PREFIX}/bin"
  end

  def post_install
    # Sign to ensure proper execution of the app bundle
    system "/usr/bin/codesign", "-f", "-s", "-", "#{prefix}/Morpheus.app" if OS.mac? && Hardware::CPU.arm?
  end

  test do
    (testpath/"test.xml").write <<~XML
      <?xml version='1.0' encoding='UTF-8'?>
      <MorpheusModel version="4">
          <Description>
              <Details></Details>
              <Title></Title>
          </Description>
          <Space>
              <Lattice class="linear">
                  <Neighborhood>
                      <Order>optimal</Order>
                  </Neighborhood>
                  <Size symbol="size" value="1.0, 1.0, 0.0"/>
              </Lattice>
              <SpaceSymbol symbol="space"/>
          </Space>
          <Time>
              <StartTime value="0"/>
              <StopTime value="0"/>
              <TimeSymbol symbol="time"/>
          </Time>
          <Analysis>
              <ModelGraph format="dot" reduced="false" include-tags="#untagged"/>
          </Analysis>
      </MorpheusModel>
    XML

    assert_match "Simulation finished", shell_output("#{bin}/morpheus --file test.xml")
  end
end