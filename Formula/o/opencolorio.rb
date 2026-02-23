class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "08cb6213ea4edee550ab050509d38204004bee6742c658166b1cf825d0a9381b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f96d8659cb4d97651e4b3f8e5e3adc624092a5c859e95d025bbd24bdf5ec41ad"
    sha256 cellar: :any,                 arm64_sequoia: "a20e9815ceace0fb0c920a41a67559f8bc7c8a153c5bab6e826e5d4ba9f99701"
    sha256 cellar: :any,                 arm64_sonoma:  "1bab9ea155f94659264e5b94791f74952ecdf9e7320974cb6cf8cb5686fa6b0c"
    sha256 cellar: :any,                 sonoma:        "705119ea11a5f5d0c67f73c762c6bda3808238a32be0438f8d4503ff42f2bea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ded7252eabd0991f0f02740033554ca7c08dd77b97adf6971987317f2d744ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44df1e47cada73f84b80225d7d3d6f4420c4c25b33d9d558519c4643c2e172e1"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "expat"
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "yaml-cpp"
  depends_on "zlib-ng-compat"

  on_arm do
    depends_on "sse2neon" => :build
  end

  def python3
    "python3.14"
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