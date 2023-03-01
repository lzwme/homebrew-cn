class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.4/proxsuite-0.3.4.tar.gz"
  sha256 "98ee4fb7964fb9b6d4cc7875381010c785b9d647481f2f3b2c5b98373a29ddf7"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d24debd270daf7b23aad715516ad9687e98b501da5981e0abc1fe218e0b0ee8"
    sha256 cellar: :any,                 arm64_monterey: "df29a823a8e19ad76a528b5fd2794deafb9784928c617a3b0c90fd0aebebf51d"
    sha256 cellar: :any,                 arm64_big_sur:  "75689b3f6638c2cc98f15e3cc28969fcbe962ec7c5c94e83e3c95256daf34bec"
    sha256 cellar: :any,                 ventura:        "b2ea1b3e96e68ff6de343df72d88a2fa8c5e4eb44da397c1a058b3ba35586946"
    sha256 cellar: :any,                 monterey:       "c5f0ff40a69c3c34a9d3b16eaa377457cd69cff7adef11b6433386a5bd21a9c2"
    sha256 cellar: :any,                 big_sur:        "9d7ff084869a2868b9e342d2b5296d6dd722f28e326e214aa09b6ae66776b8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23725e086cf7ccb7ea89e8ea13f193bd88bab10133cc0792fa1a446a2daa4e54"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "scipy"
  depends_on "simde"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end