class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https:github.comandialbrechtsqlparse"
  url "https:files.pythonhosted.orgpackages57615bc3aff85dc5bf98291b37cf469dab74b3d0aef2dd88eade9070a200af05sqlparse-0.5.2.tar.gz"
  sha256 "9e37b35e16d1cc652a2545f0997c1deb23ea28fa1f3eefe609eee3063c3b105f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "407c2129bfab723976c19588513d598fb35024ab5d680f7760d230a3197fcb3b"
  end

  depends_on "python@3.13"

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