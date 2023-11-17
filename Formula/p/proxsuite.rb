class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.1/proxsuite-0.6.1.tar.gz"
  sha256 "41b2bc12e30524e53777a4849dcfbbeb9a260aba885c3ff79ef75c4e647c71ab"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acd788c99cf98fd2fde556bd783f072ce67eacc5d2f6e4b74f2c02dba5b95839"
    sha256 cellar: :any,                 arm64_ventura:  "9496e5cdaab5374fec4aa024cabfe230c61f6b9b48577cd7c920bfa413d8421a"
    sha256 cellar: :any,                 arm64_monterey: "999c32eda10fb649592e9f8f0ac1032f6e5eaf7a7f10c4cc778b8052c0c06b43"
    sha256 cellar: :any,                 sonoma:         "d86b3bc548d72c8c76db4e7c215bb4ebfb1c2f600d4ec193bb3cf6a0d5c5cade"
    sha256 cellar: :any,                 ventura:        "7e6a369c78c15a078c6d3874aceddbce7aaeb04cdf7780b5359d476d80fcccfc"
    sha256 cellar: :any,                 monterey:       "b5d75bde4463541e26c756097826f2092745b4469c7f6c5ed7ce9abf81203bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8692292d3e4177ba3af6ed20328849cd537f6fea73e20dfbba13d9758cc351ce"
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