class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/https://github.com/Simple-Robotics/proxsuite/releases/download/v0.5.1/proxsuite-0.5.1.tar.gz"
  sha256 "0f231b16bcd14f942b10481995bec7e5fbd707b2477b708857dcaf6f1232b5cd"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9ed44af07067f6f019d1b79dc902fe33f94a15cdad8977119ca6255b4cda020"
    sha256 cellar: :any,                 arm64_ventura:  "30778e4275ccfc987205d0d9df8e7e0fe4c66dd80f9fe57eb78b56b7e35fdbf6"
    sha256 cellar: :any,                 arm64_monterey: "c54bc46cc88ae03e9f8524167840323794f07893ba11207c5201bab5e8158fb7"
    sha256 cellar: :any,                 sonoma:         "83830a285da0c2cb90cb420e175875ce9d7d69745eaf10f3e27d4d06ab39c615"
    sha256 cellar: :any,                 ventura:        "67d7e08e12598111f5b2c31e7e191149d463ef91e09e4dd01f15b3170169d711"
    sha256 cellar: :any,                 monterey:       "81dccf2950a5434093ec0a1fbd17db711e59694f6cd0f2142e4ce0e99518f272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350410cbb9f5001c7687b3bbb6bc31caf60a8a56520481d2916e86d63e7c1399"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"
  depends_on "simde"

  def python3
    "python3.12"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

    pyver = Language::Python.major_minor_version python3
    python_exe = Formula["python@#{pyver}"].opt_libexec/"bin/python"

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python_exe}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pyver = Language::Python.major_minor_version python3
    python_exe = Formula["python@#{pyver}"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end