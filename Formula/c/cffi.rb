class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
  sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "055f741e8aea1859fef03a2411b8a212bfa52df2ef2af92e406a39da80c38bfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fc5b431b1b0fe3ffd6fbaa8a971c6a90fb0fd3d04546196c6a0b06e4b2febde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "523b00cf3b61a665e19ea1511ecf6bf297ead3e61cd990add5c42ddc7c8a78b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed75fad526297630484f618319a76d51bc8a6a08dd5614452f5dd1b779e66c77"
    sha256 cellar: :any_skip_relocation, ventura:        "23bbe37b7a777a0f2a47686f87773784194ec7adf0698b47aa9bf8f7c7481cce"
    sha256 cellar: :any_skip_relocation, monterey:       "404352ffd01e392bff60745d0d2b17988d71d990bef27596a4b06eaf657e0bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bebf686878c7eb40b83df3af01b0dbc94fd39c44dd5d19e8f2a7e7e122e1c2b"
  end

  depends_on "pycparser"
  depends_on "python@3.11"
  uses_from_macos "libffi"

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"sum.c").write <<~EOS
      int sum(int a, int b) { return a + b; }
    EOS

    system ENV.cc, "-shared", "sum.c", "-o", testpath/shared_library("libsum")

    (testpath/"sum_build.py").write <<~PYTHON
      from cffi import FFI
      ffibuilder = FFI()

      declaration = """
        int sum(int a, int b);
      """

      ffibuilder.cdef(declaration)
      ffibuilder.set_source(
        "_sum_cffi",
        declaration,
        libraries=['sum'],
        extra_link_args=['-L#{testpath}', '-Wl,-rpath,#{testpath}']
      )

      ffibuilder.compile(verbose=True)
    PYTHON

    system python3, "sum_build.py"
    assert_equal 3, shell_output("#{python3} -c 'import _sum_cffi; print(_sum_cffi.lib.sum(1, 2))'").to_i
  end
end