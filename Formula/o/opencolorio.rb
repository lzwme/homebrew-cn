class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "784ac37bde5b9c6e5dc15f23d1235bd1452d376cdc03627d6d6dd310f375a735"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a764ad21304d7562723eb1938fe33246a4405b21064c021e09dac8ea18f3ad2"
    sha256 cellar: :any, arm64_tahoe:       "467cd0b91a9b07cb25a54592b65f7f5e2ffa71a4ea74bc4db553771aa2544323"
    sha256 cellar: :any, arm64_sequoia:     "2770dbb2a624170a938ffffe158f3e9828ed79dfd90d3fbb7ab9dc98539f7f73"
    sha256 cellar: :any, arm64_linux:       "24f3f1ef831c8d4fd9201b1c62f1de3e0c96b0d36eabbee523ede0aea5bc4efb"
    sha256 cellar: :any, x86_64_linux:      "7f7733a1913f6e80a28164ac1400f7251d7cb3da31c59ae14d10f85ce325b4cd"
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