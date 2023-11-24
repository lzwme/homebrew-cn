class PythonTabulate < Formula
  desc "Pretty-print tabular data in Python"
  homepage "https://github.com/astanin/python-tabulate"
  url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ca82727ef78f7d331376f9efbf41cc30be2cb360e152b6a0d2c5598db587af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb7b857656008430de487cd7857be570b1be30c3d9f9b424f018427225c1f72a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fda06e4337f59b0dcadb2ba7a9dcceb20fe4af6d0b94aa3db4266e8968a51a39"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc39a57ecdfca7b246ee977e1d5d6cbd89f9380a3ed9b6b2a92e26da931f1188"
    sha256 cellar: :any_skip_relocation, ventura:        "ec65515d9973b2d2a1a5769693758e7a7a5fa229547e000ee1f680e056d03bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "ce09838138626262d49f419571b95f5463ed77f7755e59b07bcec48f2ccf753b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bbde18d6b5f051024d82ea01797c4d851c143837092d248f3dbc49c76f4eac5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test] # FIXME: should be runtime dependency

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `tabulate`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from tabulate import tabulate"
    end

    (testpath/"in.txt").write <<~EOS
      name qty
      eggs 451
      spam 42
    EOS

    (testpath/"out.txt").write <<~EOS
      +------+-----+
      | name | qty |
      +------+-----+
      | eggs | 451 |
      +------+-----+
      | spam | 42  |
      +------+-----+
    EOS

    assert_equal (testpath/"out.txt").read, shell_output("#{bin}/tabulate -f grid #{testpath}/in.txt")
  end
end