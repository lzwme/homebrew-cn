class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/8e/22/ea637422dedf0bf36f3ef238eab4e455e2a0dcc3082b5cc067615347ab8e/mypy-1.17.1.tar.gz"
  sha256 "25e01ec741ab5bb3eec8ba9cdb0f769230368a22c959c4937360efb89b7e9f01"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2014451f3638c5d5def74cb344e037046f2564b245a4b250288021144bb734c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bf5baaa9e67514638e03108bac45cb84e9605fd09d032f9494379c8de736472"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce1768813ae5a3dadc78eec109cf911efa8b489c1852dc06ff2ca6c8a50ec5ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "413edfa6e036df37fc28e9016ca6f6b79e5efc854c2f99d59fa444eb42efeac2"
    sha256 cellar: :any_skip_relocation, ventura:       "c991191c9c93d6bcf92a7a7ee294f4c5cd74fc5fc28f22f9577b42c54b42ab54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8ee0aae32bca41a7d6b7f8ab8b934b825dd605e916224a631c69c47ef4a617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b375096f7aefaddea8c9db0b5afcc2220fb4d936e920333e2cd2b58971de9ba9"
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