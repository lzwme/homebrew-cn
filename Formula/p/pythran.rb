class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https://pythran.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/2c/ab/a647b8cc3ac1aa07cde06875157696e4522958fb8363474bce21c302d4d8/pythran-0.14.0.tar.gz"
  sha256 "42f3473946205964844eff7f750e2541afb2006d53475d708f5ff2d048db89bd"
  license "BSD-3-Clause"
  head "https://github.com/serge-sans-paille/pythran.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68c8e776ff4199736c205c5fde2c1f8355b1796473706435636161bfb7a72a3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c37f9f8f4914d3e74a145f9598c9137fc2ee9f40dcdbd6cb5bd8a72ff93b2c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "897a135c0f769cb7ffc7d8200c37b9b13fbfe22f4387c7008a10cb376c213e25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f67527b131d933a6dd69510bd754537d96c14830da13bb2833004ab7362fb4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6a9dc5377d0c4bdb0dd8f7c1d0965a7e64c8e8dd48c87a0abcf4cd670ff7810"
    sha256 cellar: :any_skip_relocation, ventura:        "cab648f53f29b83692f413ed2aa6f7719c1b75c40ff037659123a8ca2ff17be1"
    sha256 cellar: :any_skip_relocation, monterey:       "d4228900b2c9a4c1825764f50f6697f7b62c42c60b0fc2b26cf3effcffc418f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "711383b5b04bee04c1e31943fa9061c9551d129cdde9ba1d3bcc926acd331422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6030a5ab0a87948f949eb9e3cb9ad2a6ba6f55efd255ada8d9618545d325cb06"
  end

  depends_on "gcc" # for OpenMP
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.11"
  depends_on "six"

  resource "beniget" do
    url "https://files.pythonhosted.org/packages/14/e7/50cbac38f77eca8efd39516be6651fdb9f3c4c0fab8cf2cf05f612578737/beniget-0.4.1.tar.gz"
    sha256 "75554b3b8ad0553ce2f607627dad3d95c60c441189875b98e097528f8e23ac0c"
  end

  resource "gast" do
    url "https://files.pythonhosted.org/packages/e4/41/f26f62ebef1a80148e20951a6e9ef4d0ebbe2090124bc143da26e12a934c/gast-0.5.4.tar.gz"
    sha256 "9c270fe5f4b130969b54174de7db4e764b09b4f7f67ccfc32480e29f78348d97"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    if OS.mac?
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      inreplace "pythran/pythran-darwin.cfg" do |s|
        s.gsub!(/^include_dirs=/, "include_dirs=#{Formula["openblas"].opt_include}")
        s.gsub!(/^library_dirs=/, "library_dirs=#{Formula["openblas"].opt_lib}")
        s.gsub!(/^blas=.*/, "blas=openblas")
        s.gsub!(/^CC=.*/, "CC=#{Formula["gcc"].opt_bin}/gcc-#{gcc_major_ver}")
        s.gsub!(/^CXX=.*/, "CXX=#{Formula["gcc"].opt_bin}/g++-#{gcc_major_ver}")
      end
    end

    virtualenv_install_with_resources
  end

  test do
    pythran = Formula["pythran"].opt_bin/"pythran"
    python = Formula["python@3.11"].opt_libexec/"bin/python"

    (testpath/"dprod.py").write <<~EOS
      #pythran export dprod(int list, int list)
      def dprod(arr0, arr1):
        return sum([x*y for x,y in zip(arr0, arr1)])
    EOS
    system pythran, testpath/"dprod.py"
    rm_f testpath/"dprod.py"
    assert_equal "11", shell_output("#{python} -c 'import dprod; print(dprod.dprod([1,2], [3,4]))'").chomp

    (testpath/"arc_distance.py").write <<~EOS
      #pythran export arc_distance(float[], float[], float[], float[])
      import numpy as np
      def arc_distance(theta_1, phi_1, theta_2, phi_2):
        """
        Calculates the pairwise arc distance between all points in vector a and b.
        """
        temp = np.sin((theta_2-theta_1)/2)**2 + np.cos(theta_1)*np.cos(theta_2)*np.sin((phi_2-phi_1)/2)**2
        distance_matrix = 2 * np.arctan2(np.sqrt(temp), np.sqrt(1-temp))
        return distance_matrix
    EOS
    # Test with configured gcc to detect breakages from gcc major versions and for OpenMP support
    with_env(CC: nil, CXX: nil) do
      system pythran, "-DUSE_XSIMD", "-fopenmp", "-march=native", testpath/"arc_distance.py"
    end
    rm_f testpath/"arc_distance.py"

    system python, "-c", <<~EOS
      import numpy as np
      import arc_distance
      d = arc_distance.arc_distance(
        np.array([12.4,0.5,-5.6,12.34,9.21]), np.array([-5.6,3.4,2.3,-23.31,12.6]),
        np.array([3.45,1.5,55.4,567.0,43.2]), np.array([56.1,3.4,1.34,-56.9,-3.4]),
      )
      assert ([1.927, 1., 1.975, 1.83, 1.032] == np.round(d, 3)).all()
    EOS
  end
end