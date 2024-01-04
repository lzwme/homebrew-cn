class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https:www.numpy.org"
  url "https:files.pythonhosted.orgpackagesd0b013e2b50c95bfc1d5ee04925eb5c105726c838f922d0aaddd57b7c8be0f8bnumpy-1.26.3.tar.gz"
  sha256 "697df43e2b6310ecc9d95f05d5ef20eacc09c7c4ecc9da3f235d39e71b7da1e4"
  license "BSD-3-Clause"
  head "https:github.comnumpynumpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53605ab2edf1a9410a6364274662dac00f8827408f9aec55d1ed3100e2618419"
    sha256 cellar: :any,                 arm64_ventura:  "23d451d38178ed316626fdf919b4a43e069040db7f8eb802256d459ddac8fccf"
    sha256 cellar: :any,                 arm64_monterey: "0af87e29714bd725b1fd4b440a1ceace9235a32425eb8890c05e1ee5cdf44008"
    sha256 cellar: :any,                 sonoma:         "885a65964840e582380c804ba15d03cd843f5eacfa10b5688fc8994ed212e3cb"
    sha256 cellar: :any,                 ventura:        "aa648e5665242850c56ad9edfb4ad7a5ebc4c1183898bdcf15aa4358953755c5"
    sha256 cellar: :any,                 monterey:       "6870a2850ae62638320b8b0a124391d4edbef363774af173e2bdd5415b3fe4a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1431374f2f591fb15a13859a2310d3e6a7f1db844a11b60925210fa90ef1c1c2"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(^python@\d\.\d+$) }
        .sort_by(&:version) # so that `binf2py` and `binf2py3` use newest python
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_libshared_library("libopenblas")

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      site_packages = Language::Python.site_packages(python_exe)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexecsite_packages

      system python_exe, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}gfortran",
                                              "--parallel=#{ENV.make_jobs}"
      system python_exe, *Language::Python.setup_install_args(prefix, python_exe)
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end