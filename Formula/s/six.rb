class Six < Formula
  desc "Python 2 and 3 compatibility utilities"
  homepage "https:github.combenjaminpsix"
  url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
  sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af0e594f44ac758201a84eda10f5eec0e7958ac67c219c6a09165eb18ac79797"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).select { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, *Language::Python.setup_install_args(prefix, python_exe)
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `six` module for Python #{python_versions}.
      If you need `six` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec"binpython", "-c", <<~EOS
        import six
        assert not six.PY2
        assert six.PY3
      EOS
    end
  end
end