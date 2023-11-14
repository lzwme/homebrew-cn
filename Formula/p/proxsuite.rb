class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.0/proxsuite-0.6.0.tar.gz"
  sha256 "d227ac60e10b18b52e91364b2fa35c3a36cbd7572959ed4e0684cd9bafa80c93"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "153688a27aae5dd7076e313c00cec35845715e7b459c7d2e8efa5a6914f3ca35"
    sha256 cellar: :any,                 arm64_ventura:  "81f189e284a475f280acf95ad4306cc133ad0072dc161e41d209c1628fe636fc"
    sha256 cellar: :any,                 arm64_monterey: "424aaa2162bde154921e2e6c8947a07f8f31809d86c0e260878d87a95bcb634c"
    sha256 cellar: :any,                 sonoma:         "7808ce3c501572c2082b86e053f6dd7672911186871dd1b3ee3b1fdd43614791"
    sha256 cellar: :any,                 ventura:        "5cbcf0f3debd4d6d20ba6836551f870dbccefbc3a496000b39f468fdd8ef0c48"
    sha256 cellar: :any,                 monterey:       "328ae140a4740bc6b93b367f93cfe6d8c68c38af37ffcef7f9f5d73b81e16e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44cc14efc85f6014de6ad8d24401fc09f5a3ae52c62763f58cddbd3df4e3fedd"
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