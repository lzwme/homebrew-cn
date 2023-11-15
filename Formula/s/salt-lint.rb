class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aa6d52ad713ad741107e27746cf36349d3bf6503c48c7dacfe059680522c7af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff87917f1c01f50567df9f03939b239d5efb0b8a26e35c71948a87245112bd09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd386d5dabf7425a6ff46fcdf019c8b0db487e313fcef28f7f5c8c307af341fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a22c60f222b99cf485deae3dcb79102996ad9da397188b4285e7d92b52712440"
    sha256 cellar: :any_skip_relocation, ventura:        "8c1575dd9c2072c3e4d64a48f8efd0a41a2e1f6362d04ca1e6e42ce590ed21e0"
    sha256 cellar: :any_skip_relocation, monterey:       "93b3f147408614ca88f3b2b51982659d7c47296d0a30d0e56197335c429bb309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6fa24e67b78fcbd393fc6b4906dc96b33d5ad4fb9cbbc5df513afc09fd5c813"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f4/8e/f91cffb32740b251cff04cad1e7cdd2c710582c735a01f56307316c148f2/pathspec-0.11.0.tar.gz"
    sha256 "64d338d4e0914e91c1792321e6907b5a593f1ab1851de7fc269557a21b30ebbc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sls").write <<~EOS
      /tmp/testfile:
        file.managed:
            - source: salt://{{unspaced_var}}/example
    EOS
    out = shell_output("#{bin}/salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end