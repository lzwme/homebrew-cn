class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/b0/29/a509301332714aacc10ff98b7fe6539a9a1f96b18698efe9666ceae1485c/invoke-2.1.0.tar.gz"
  sha256 "277894c57fa2b77f22ed3c7726fb8689773301e4497ccb2a59f19bc7bbbe5b4a"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e7856a4a27b4cb5ac99b43b29ad2b44d98ea583990b9f12f5c88e68f10396c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b29aec348ad752b4862c21386e72a6d9c456c832bb64d6056959e7609d194c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbcc7f34c77bb10d512886d4503ca84a0765362fc416f61816318e584af4f94a"
    sha256 cellar: :any_skip_relocation, ventura:        "9a5bbea74424ece0ea72c3f2ad51969c5c2c3c5fbf24a9bec5039f32a730179a"
    sha256 cellar: :any_skip_relocation, monterey:       "7cc84b15ae8275a61048c6981a05b277bcaf2ea0eca2fa6199493846b315976f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a70ce5b397d03ae22032d2e7464ca17afd974fdfe8959876ecf0e7eba13dc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96ae727d1cca333c1f4e55dd2dd0a2bea1419ce2e48f9411d19da3502efabb0d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<~EOS
      from invoke import run, task

      @task
      def clean(ctx, extra=''):
          patterns = ['foo']
          if extra:
              patterns.append(extra)
          for pattern in patterns:
              run("rm -rf {}".format(pattern))
    EOS
    (testpath/"foo"/"bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean\" should have deleted \"foo\""
    assert_predicate testpath/"baz", :exist?, "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_predicate testpath/"baz", :exist?, "pyinvoke clean-extra should have deleted \"baz\""
  end
end