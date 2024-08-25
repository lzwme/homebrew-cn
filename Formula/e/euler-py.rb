class EulerPy < Formula
  include Language::Python::Virtualenv

  desc "Project Euler command-line tool written in Python"
  homepage "https:github.comiKevinYEulerPy"
  url "https:files.pythonhosted.orgpackagesa641f074081bc036fbe2f066746e44020947ecf06ac53b6319a826023b8b5333EulerPy-1.4.0.tar.gz"
  sha256 "83b2175ee1d875e0f52b0d7bae1fb8500f5098ac6de5364a94bc540fb9408d23"
  license "MIT"
  revision 3
  head "https:github.comiKevinYEulerPy.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a26e52b98389ea59d09c6fa089b3bdd4bdb27eb95269692f96cc5f0b4e819cfd"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    # Unpin old click version: https:github.comiKevinYEulerPycommit9923d2ee026608e33026909bb95c444724b08ba2
    inreplace "requirements.txt", "click==4.0", "click"
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}euler", "Y\n")
    assert_match 'Successfully created "001.py".', output
    assert_predicate testpath"001.py", :exist?
  end
end