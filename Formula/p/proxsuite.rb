class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https:github.comSimple-Roboticsproxsuite"
  url "https:github.comSimple-Roboticsproxsuitereleasesdownloadv0.6.2proxsuite-0.6.2.tar.gz"
  sha256 "0b65faa436f44cf99e94b52c1b0308253872dbc8b53d496034284b0edab8f08f"
  license "BSD-2-Clause"
  head "https:github.comSimple-Roboticsproxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1006943edbd1bba151c958b273aee7f703ae23de29cca46d0bc9e40c21f3d765"
    sha256 cellar: :any,                 arm64_ventura:  "0d1f4f7d8d7bf70552360e94037bfa9f0f1f81262922e10fa638446c2d47ae0b"
    sha256 cellar: :any,                 arm64_monterey: "5d82dba34703d35c92c42dc2986b562d0b41348b61c19d96ceca6e0fba1a2c0a"
    sha256 cellar: :any,                 sonoma:         "90498d5b7c4d2b6d54bb336b6d2bc9bf0df5fab3c987f981f0d094adfe289da7"
    sha256 cellar: :any,                 ventura:        "408cee8b9bec44601a2b695191a9f2fc510bf05bb7003f16af65f803adea9ac1"
    sha256 cellar: :any,                 monterey:       "addd15e4043c7f80898bd4d08c651384c6bfc0cc04b3fe10f06e3cc52ab08ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "705dd62c1701dc0c78fc2a570a8ed9bc10d73ab2f12c139f4c4c9eec7e009548"
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
    python_exe = Formula["python@#{pyver}"].opt_libexec"binpython"

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefixLanguage::Python.site_packages

    # simde include dir can be removed after https:github.comSimple-Roboticsproxsuiteissues65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python_exe}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pyver = Language::Python.major_minor_version python3
    python_exe = Formula["python@#{pyver}"].opt_libexec"binpython"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end