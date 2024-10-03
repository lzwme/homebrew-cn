class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https:opencolorio.org"
  url "https:github.comAcademySoftwareFoundationOpenColorIOarchiverefstagsv2.4.0.tar.gz"
  sha256 "0ff3966b9214da0941b2b1cbdab3975a00a51fc6f3417fa860f98f5358f2c282"
  license "BSD-3-Clause"
  head "https:github.comAcademySoftwareFoundationOpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aefcbd3cbd0796423605897b683907146e8cd167b214b35f6bda60fac1c08207"
    sha256 cellar: :any,                 arm64_sonoma:  "8a22df75a072b5cea307d73cf1fc74ff10739dde9f6b2bf963cdf4f51344db33"
    sha256 cellar: :any,                 arm64_ventura: "92fb658911498cfd92398980a1214e0c5f116da0f2318c7cb0a1212aae8cffc0"
    sha256 cellar: :any,                 sonoma:        "bc95e94b7c6e273af9dc62dfc0e17e2a79b5aebcb86b1153a33feba2341ca256"
    sha256 cellar: :any,                 ventura:       "058a70bf3e3341e364b1be0228956b51b9550d81f44245ef2ff4b68bcceb6bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8883d8439c781a6c57fdc9ae3c120a8077a22bcfaf5d2473ffceeff7f497730"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "python@3.12"
  depends_on "yaml-cpp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  def python3
    "python3.12"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DOCIO_BUILD_GPU_TESTS=OFF
      -DOCIO_BUILD_TESTS=OFF
      -DOCIO_INSTALL_EXT_PACKAGES=NONE
      -DOCIO_PYTHON_VERSION=#{Language::Python.major_minor_version python3}
      -DPython_EXECUTABLE=#{which(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}shareociosetup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https:opencolorio.orginstallation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https:opencolorio.orgdownloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}ociocheck --help", 1)
    system python3, "-c", "import PyOpenColorIO as OCIO; print(OCIO.GetCurrentConfig())"
  end
end