class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https:www.numpy.org"
  url "https:files.pythonhosted.orgpackages0535fb1ada118002df3fe91b5c3b28bc0d90f879b881a5d8f68b1f9b79c44bfenumpy-2.0.0.tar.gz"
  sha256 "cf5d1c9e6837f8af9f92b6bd3e86d513cdc11f60fd62185cc49ec7d1aba34864"
  license "BSD-3-Clause"
  head "https:github.comnumpynumpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd895652221b39720286180cb96e82973fdf02c8618d0e80e73226abb605c27a"
    sha256 cellar: :any,                 arm64_ventura:  "908a8cc92dce11ec5ee29ddf93badc2ababf2354b7fbab3a1dd380a5269222a2"
    sha256 cellar: :any,                 arm64_monterey: "9709e51ce8f1bcf4310791cdea980f941a05dd59b8ef340463c41092180af107"
    sha256 cellar: :any,                 sonoma:         "bf2949e8a594ff32fb7aa1717d9ec5e7802c87aa6343db50a3f8266c19ecddf9"
    sha256 cellar: :any,                 ventura:        "dd9c75e900e9bc82d65adc321ca9000876e7588adf66cc5b960ae371ed9b617f"
    sha256 cellar: :any,                 monterey:       "8e76c0d5da70462f77b79f636767812df89f42325dc0326c736563c244e39487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5051957b3488ef45762e7bddb428c01dbd63b5cf1d0c298a81570b81ef1f1bf0"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so scripts like `binf2py` use newest python
  end

  def install
    pythons.each do |python|
      python3 = python.opt_libexec"binpython"
      system python3, "-m", "pip", "install", "-Csetup-args=-Dblas=openblas",
                                              "-Csetup-args=-Dlapack=openblas",
                                              *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python3 = python.opt_libexec"binpython"
      system python3, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end