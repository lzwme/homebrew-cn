class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/fc/ed/75616c70c3e96bdfec93f6a171e87f0463d9da21b061ff8af8ae7ecda17e/invoke-2.1.1.tar.gz"
  sha256 "7dcf054c4626b89713da650635c29e9dfeb8a1dd0a14edc60bd3e16f751292ff"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde544c9795184edb956c25c6dd27bd3670845047134b3b64d0ee3ea2c9f2762"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99812af5d223d1cba41a459b1de86ca092c3772e534610b3efbfae82bd44dd6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2293519b23f9a6a51857e0c18eee6f401b891908c7b5f5e21e7804d368fcf804"
    sha256 cellar: :any_skip_relocation, ventura:        "cb8aadb52284feaf01f5e1cb714cefeee1fcdfc90c315affb24cf8c570d05788"
    sha256 cellar: :any_skip_relocation, monterey:       "fe302608600c7b0be7c07bfb5383c2a529229fba7a3cf720b893bc448ee6a2e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "380ee73ee999d8c7f89530a02132f81d21ec82dea8fa7f7a81bf359c2398f0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695fb3fc23b3abf68e018e558648faa515691772228de63db66e3328147e4c21"
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