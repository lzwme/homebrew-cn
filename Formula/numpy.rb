class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/cf/7a/f68d1d658a0e68084097beb212fa9356fee7eabff8b57231cc4acb555b12/numpy-1.25.1.tar.gz"
  sha256 "9a3a9f3a61480cc086117b426a8bd86869c213fc4072e606f01c4e4b66eb92bf"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00720c1d8576d27d957965fe9d7b4f0378dd8fdb4cd18481a5e79686e7e3eb9f"
    sha256 cellar: :any,                 arm64_monterey: "d1c71046a8ba0e602f41c0291c63d8c6a3089e4eec28179d64be624c6db23bc9"
    sha256 cellar: :any,                 arm64_big_sur:  "345c3d98a39f02ad8e4c591d844973d25502baff6fcff09468e4c5fdf0126e70"
    sha256 cellar: :any,                 ventura:        "e98441cc95a9a28d8fefe8d2202281fd50ca8f7a1c6b8775b9eb74532a0afa20"
    sha256 cellar: :any,                 monterey:       "f50e2c2e7d9d74520b650a8f25338456660a3b465083359f0ded14d16f10b2d2"
    sha256 cellar: :any,                 big_sur:        "10062b0b5d2d0bee5b09d35acc2058e704751bf00f3c873dce820ac7dc733bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44fdd69bfd05d60d1cdd717d0bf66e264d7178216b83e955b94ba0d1273a5c02"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use python3.10
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

      system python, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran",
                                          "--parallel=#{ENV.make_jobs}"
      system python, *Language::Python.setup_install_args(prefix, python)
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end