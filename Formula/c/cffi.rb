class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
  sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3af401e70845a3ddab668051310f9bbc002d60c60bacc4833c8b86fc5a350c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e9efdb077ac820c6da89abffc9bec1b1ca2cefe9e02e8789add2ab1aaaef044"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eaa19099eb9e95e0986c43c3c8474341f7396109d933a3a96db018de0de9258"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b47208d70f0014528a91ab01ecd77f980a4c4a7c93be9298d98dfa06ca5f5c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fce5151feb5271e6248a26425c3acdf8bfbc26bb08d305820c8a7d8461200822"
    sha256 cellar: :any_skip_relocation, ventura:        "a0529e6b2049317924717646ba6c7a6cf92908a614b695632c6cbfd6a088cf1c"
    sha256 cellar: :any_skip_relocation, monterey:       "c73ad8cf6404d12ef051b77a1acb68ce34c16ed2d06412e26cb14036e8dfc1bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fcbba8d42933c05b028cace85d7e6a20b9f99e16c83bd453c10ae16702cdda0"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pycparser"

  uses_from_macos "libffi"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"sum.c").write <<~EOS
      int sum(int a, int b) { return a + b; }
    EOS

    libsum = testpath/shared_library("libsum")
    system ENV.cc, "-shared", "sum.c", "-o", libsum

    (testpath/"sum.py").write <<~PYTHON
      from cffi import FFI
      ffi = FFI()

      declaration = """
        int sum(int a, int b);
      """

      ffi.cdef(declaration)
      lib = ffi.dlopen("#{libsum}")
      print(lib.sum(1, 2))
    PYTHON

    pythons.each do |python|
      assert_equal 3, shell_output("#{python} sum.py").to_i
    end
  end
end