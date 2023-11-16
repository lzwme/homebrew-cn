class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/dd/2b/205ddff2314d4eea852e31d53b8e55eb3f32b292efc3dd86bd827ab9019d/numpy-1.26.2.tar.gz"
  sha256 "f65738447676ab5777f11e6bbbdb8ce11b785e105f690bc45966574816b6d3ea"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "883125590816e213db9e7ec45b7c6f6d0291cac72001726c40779912ae3752da"
    sha256 cellar: :any,                 arm64_ventura:  "bfd739e996446722ff3dd238a314ff9ec59999c00190a7ae01c328a81f793171"
    sha256 cellar: :any,                 arm64_monterey: "ea093758cd7c5fc165f8408d98ff841c2a2b57a7267752042c751a58b8afe666"
    sha256 cellar: :any,                 sonoma:         "03c9c470038c77226b05fd1f7808f4fb2523146a45a97e57ecb34f6e87c05e77"
    sha256 cellar: :any,                 ventura:        "d9664fd0b99de89f1cfb3ccb3937618e91bebb7f32d1ccc7a9b6c5781f30ea7f"
    sha256 cellar: :any,                 monterey:       "d5e9d91c2feb7d663953a46382ede8f7392add6a7d7d00166ee0d63f1843922f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677c0f8ba6d4d43a1c77cbaa9cce8c1ea9d345020df7f5b57e1a7d5ad2eb9817"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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