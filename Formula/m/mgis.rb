class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://ghfast.top/https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-3.0.2.tar.gz"
  sha256 "189b53789d4e2af3a69970880f5b1e90ff596ad3a71109ace69b2026333a8641"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "72452bc4eb3a9ca56810a2c79a1ec63df53b84a2843471e823db17f19954d139"
    sha256 cellar: :any,                 arm64_sequoia: "bb8df48f04087ababc33d774e6a4542d99cb5f36d5a24d8be796d6db0d3d9c49"
    sha256 cellar: :any,                 arm64_sonoma:  "f27e7d1f42af7cd54d0a981c69bb4daeb1480ea92d6685d6cc071daa49c88934"
    sha256 cellar: :any,                 sonoma:        "22b1d068a5aa26c9c219257954eceec2276e2788bdab82d0a7b23e1e14d6d3c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e41d455b2f98ec10e3fd99e7347716536c1b0c7b993bba8f29356afb1a517d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c76416c69e360ac348907958717457e231d3ae8ede1b19cbc5173220ef8024"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build

  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python@3.14"

  def python3
    which("python3.14")
  end

  def install
    args = [
      "-Denable-portable-build=ON",
      "-Denable-website=OFF",
      "-Denable-enable-doxygen-doc=OFF",
      "-Denable-c-bindings=ON",
      "-Denable-fortran-bindings=ON",
      "-Denable-python-bindings=ON",
      "-Denable-pybind11=ON",         # requires pybind11
      "-Denable-fenics-bindings=OFF", # experimental and very limited
      "-Denable-julia-bindings=OFF",  # requires CxxWrap library
      "-Denable-enable-static=OFF",
      "-Ddisable_python_library_linking=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
      "-DPython_ADDITIONAL_VERSIONS=#{Language::Python.major_minor_version python3}",
    ]

    if OS.mac?
      # Use -dead_strip_dylibs to avoid linkage to boost container and graph modules
      # Issue ref: https://github.com/boostorg/boost/issues/985
      linker_flags = %W[
        -Wl,-dead_strip_dylibs
        -Wl,-rpath,#{rpath(source: prefix/Language::Python.site_packages(python3)/"mgis")}
      ]
      args << "-DCMAKE_MODULE_LINKER_FLAGS=#{linker_flags.join(" ")}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import mgis.behaviour"
    system python3, "-c", "import mgis.model"
  end
end