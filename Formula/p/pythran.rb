class Pythran < Formula
  include Language::Python::Virtualenv

  desc "Ahead of Time compiler for numeric kernels"
  homepage "https:pythran.readthedocs.io"
  url "https:files.pythonhosted.orgpackages940a95a72f09f25dae48f41e367959075ed4c7a0ff02dd3f54eec111501d648apythran-0.18.0.tar.gz"
  sha256 "5c003e8cbedf6dbb68c2869c49fc110ce8b5e8982993078a4a819f1dadc4fc6a"
  license "BSD-3-Clause"
  head "https:github.comserge-sans-paillepythran.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6588b16c72ef7f632bcf1a434202135f0f0cb58cb873258cb26271c9d685f217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6588b16c72ef7f632bcf1a434202135f0f0cb58cb873258cb26271c9d685f217"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6588b16c72ef7f632bcf1a434202135f0f0cb58cb873258cb26271c9d685f217"
    sha256 cellar: :any_skip_relocation, sonoma:        "11bd3bd4e66b3537fc2266c4b6ec241726ef50f332e5ffae4a4d0ab00e80fc99"
    sha256 cellar: :any_skip_relocation, ventura:       "11bd3bd4e66b3537fc2266c4b6ec241726ef50f332e5ffae4a4d0ab00e80fc99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6793de3b09e58d761ba1f7d7bebc062d35f69738535ba59cdca3c653a7fa123d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6793de3b09e58d761ba1f7d7bebc062d35f69738535ba59cdca3c653a7fa123d"
  end

  depends_on "gcc" # for OpenMP
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"

  resource "beniget" do
    url "https:files.pythonhosted.orgpackages2e275bb01af8f2860d431b98d0721b96ff2cea979106cae3f2d093ec74f6400cbeniget-0.4.2.post1.tar.gz"
    sha256 "a0258537e65e7e14ec33a86802f865a667f949bb6c73646d55e42f7c45a052ae"
  end

  resource "gast" do
    url "https:files.pythonhosted.orgpackages3c14c566f5ca00c115db7725263408ff952b8ae6d6a4e792ef9c84e77d9af7a1gast-0.6.0.tar.gz"
    sha256 "88fc5300d32c7ac6ca7b515310862f71e6fdf2c029bbec7c66c0f5dd47b6b1fb"
  end

  resource "ply" do
    url "https:files.pythonhosted.orgpackagese569882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4daply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages8dd2ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fesetuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  def install
    if OS.mac?
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      inreplace "pythranpythran-darwin.cfg" do |s|
        s.gsub!(^include_dirs=, "include_dirs=#{Formula["openblas"].opt_include}")
        s.gsub!(^library_dirs=, "library_dirs=#{Formula["openblas"].opt_lib}")
        s.gsub!(^blas=.*, "blas=openblas")
        s.gsub!(^CC=.*, "CC=#{Formula["gcc"].opt_bin}gcc-#{gcc_major_ver}")
        s.gsub!(^CXX=.*, "CXX=#{Formula["gcc"].opt_bin}g++-#{gcc_major_ver}")
      end
    end

    virtualenv_install_with_resources
  end

  test do
    python3 = which("python3.13")
    pythran = Formula["pythran"].opt_bin"pythran"

    (testpath"dprod.py").write <<~PYTHON
      #pythran export dprod(int list, int list)
      def dprod(arr0, arr1):
        return sum([x*y for x,y in zip(arr0, arr1)])
    PYTHON
    system pythran, testpath"dprod.py"
    rm(testpath"dprod.py")

    assert_equal "11", shell_output("#{python3} -c 'import dprod; print(dprod.dprod([1,2], [3,4]))'").chomp

    (testpath"arc_distance.py").write <<~PYTHON
      #pythran export arc_distance(float[], float[], float[], float[])
      import numpy as np
      def arc_distance(theta_1, phi_1, theta_2, phi_2):
        """
        Calculates the pairwise arc distance between all points in vector a and b.
        """
        temp = np.sin((theta_2-theta_1)2)**2 + np.cos(theta_1)*np.cos(theta_2)*np.sin((phi_2-phi_1)2)**2
        distance_matrix = 2 * np.arctan2(np.sqrt(temp), np.sqrt(1-temp))
        return distance_matrix
    PYTHON

    # Test with configured gcc to detect breakages from gcc major versions and for OpenMP support
    with_env(CC: nil, CXX: nil) do
      system pythran, "-DUSE_XSIMD", "-fopenmp", "-march=native", testpath"arc_distance.py"
    end
    rm(testpath"arc_distance.py")

    system python3, "-c", <<~PYTHON
      import numpy as np
      import arc_distance
      d = arc_distance.arc_distance(
        np.array([12.4,0.5,-5.6,12.34,9.21]), np.array([-5.6,3.4,2.3,-23.31,12.6]),
        np.array([3.45,1.5,55.4,567.0,43.2]), np.array([56.1,3.4,1.34,-56.9,-3.4]),
      )
      assert ([1.927, 1., 1.975, 1.83, 1.032] == np.round(d, 3)).all()
    PYTHON
  end
end