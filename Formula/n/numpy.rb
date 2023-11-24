class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/dd/2b/205ddff2314d4eea852e31d53b8e55eb3f32b292efc3dd86bd827ab9019d/numpy-1.26.2.tar.gz"
  sha256 "f65738447676ab5777f11e6bbbdb8ce11b785e105f690bc45966574816b6d3ea"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "59af7bc320b4d6d3652387d6bd82427b71f15982f6d11d6c82b5043e4cc11fcb"
    sha256 cellar: :any,                 arm64_ventura:  "e260547f705e28ba65f77404b5a9c9c0db3b840e5aa3597bc4f28283da810dac"
    sha256 cellar: :any,                 arm64_monterey: "abc0899cc61f0d10231156b93a10965093dd27aaec050e8eb8cb9f9552933a07"
    sha256 cellar: :any,                 sonoma:         "eaec11a16b2971a7d7501af8328ebd62a64183f6a3b23f8f31b64392f3ea5d0a"
    sha256 cellar: :any,                 ventura:        "3e485bbb751d7d04a80d257b7c3a5179763df96c3c4f713b858baf55b94a8593"
    sha256 cellar: :any,                 monterey:       "6119201c3bc3d614118bab056231353223cf921d3507c24f7011c1f60250a18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1704539203b85d71127dcac8764ca0505f2c75f12a671b343dbad3fedca8195"
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
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use newest python
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
      python_exe = python.opt_libexec/"bin/python"
      site_packages = Language::Python.site_packages(python_exe)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

      system python_exe, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran",
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
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end