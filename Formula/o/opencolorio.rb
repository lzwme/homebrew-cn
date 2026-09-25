class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "722601e01b78b7a12da4829cb450674935f404b0e508f3f20046fa77570e3272"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "47e5a000a0dee9e5c18548c9b15297647b3077c5af3b8815fffd847e0d897a76"
    sha256 cellar: :any, arm64_tahoe:       "2519a0398a5815e8159a67f15fa5c4efb378712cfcedb2b15e4e1882563bccc8"
    sha256 cellar: :any, arm64_sequoia:     "cf7448c782008716e5892d907a7080dac09ee3510ee2a9f5b232a18350eed318"
    sha256 cellar: :any, arm64_linux:       "32882dc5a7d237d3d87132e7bc50f9bc73eb728d6f1e187b8089d797f2899e06"
    sha256 cellar: :any, x86_64_linux:      "2acc6be54d12aaf29ecb47bbc0de030ea97771c56131c8e32dd99b0807561dd6"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "yaml-cpp"
  depends_on "zlib-ng-compat"

  uses_from_macos "expat", since: :sequoia # expat 2.6.0+ (Apple expat-37)

  on_arm do
    depends_on "sse2neon" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DOCIO_BUILD_GPU_TESTS=OFF
      -DOCIO_BUILD_TESTS=OFF
      -DOCIO_INSTALL_EXT_PACKAGES=NONE
      -DOCIO_PYTHON_VERSION=#{Language::Python.major_minor_version python3}
      -DPython_EXECUTABLE=#{python3}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
    system python3, "-c", "import PyOpenColorIO as OCIO; print(OCIO.GetCurrentConfig())"
  end
end