class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https:github.comandialbrechtsqlparse"
  url "https:files.pythonhosted.orgpackages7382dfa23ec2cbed08a801deab02fe7c904bfb00765256b155941d789a338c68sqlparse-0.5.1.tar.gz"
  sha256 "bb6b4df465655ef332548e24f08e205afc81b9ab86cb1c45657a7ff173a3a00e"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d38b5802e084d154b4944b9bd3a4eae4733a64ba0a12f853f62c7d14a2da3514"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    man1.install "docssqlformat.1"
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end