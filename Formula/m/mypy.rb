class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/1e/e3/034322d5a779685218ed69286c32faa505247f1f096251ef66c8fd203b08/mypy-1.17.0.tar.gz"
  sha256 "e5d7ccc08ba089c06e2f5629c660388ef1fee708444f1dee0b9203fa031dee03"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a104929e361436f855b0a3ae534cdec59a8ac327169bcafd2834dab7c2f0bbfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e4cc02fe48de46479e21c54dd52cd75ecceae89cc6b79c562e2dc14fff2222"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a48eea34913d1b187ff36e068550f6f269efe781f68c11238708f78ea722ab30"
    sha256 cellar: :any_skip_relocation, sonoma:        "b91c7cd4c41edcfdcb19ca401ac9f80b1a9d16c967519112f1afae93ad14fd75"
    sha256 cellar: :any_skip_relocation, ventura:       "feb0f80ca350a6a350528173177b1b287a6447e4f1a603709fd12f4eba8aa64d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2aedf563d8ac3a3f8c7833ac8ee9eec8d896aa9a272ceb4c4225285c4b8e092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f17d980d52579b59da6acd228b0f5968e9b61ef064a8899162df3a479a49ec3"
  end

  depends_on "python@3.13"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def p() -> None:
        print('hello')
      a = p()
    PYTHON
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end