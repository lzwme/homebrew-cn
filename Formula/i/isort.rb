class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https:pycqa.github.ioisort"
  url "https:files.pythonhosted.orgpackages87f9c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5isort-5.13.2.tar.gz"
  sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  license "MIT"
  head "https:github.comPyCQAisort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?packages.*?isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a491e2da01cf99435dcf1357bf1cae158f6c57377a25ff3c4f0e3cfd60dcd189"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath"isort_test.py").read
  end
end