class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/https://github.com/Simple-Robotics/proxsuite/releases/download/v0.4.0/proxsuite-0.4.0.tar.gz"
  sha256 "42950617fb3bf36064db249540c1036b966aa7bfe9b6a76d763dbbbf0c3d661d"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0826224a9fed51181af63d346b46542ddb3b35905453e5500e89c0d07aad079c"
    sha256 cellar: :any,                 arm64_monterey: "c000a1fb7871ae2dce96d5ed7fa061eedae844649dc80676d509dff50aa86e6b"
    sha256 cellar: :any,                 arm64_big_sur:  "c44c8674e526426b9c77a05a59d436cf52611e76c0432ba4eb97c57a63f68491"
    sha256 cellar: :any,                 ventura:        "b4dcc24b1075fd5156f541c5af2bbf6afb59ed21111358d717d4e5dfae8ba04e"
    sha256 cellar: :any,                 monterey:       "5cf89e95f8afd5a6ece3004923462fb49ed1870ab4919a7d3209bcfd440ad889"
    sha256 cellar: :any,                 big_sur:        "d4db4b7f93c56b29688c424ccc79d80aea609b7205487c333a6f0b900e35cb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a03020cafaf15ba0d4de6146eb637162ee49849569644fa20fd9c1670f275df"
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
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

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