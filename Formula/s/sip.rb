class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https:python-sip.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagese3111ad8d00e08f26eaa45c48c085b8fdb6aba32b5c96e601d96b4b821a5b88esip-6.11.0.tar.gz"
  sha256 "237d24ead97a5ef2e8c06521dd94c38626e43702a2984c8a2843d7e67f07e799"
  license "BSD-2-Clause"
  head "https:github.comPython-SIPsip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab21cd7892b01ce7e5d2af53ecd973b8c65c711df6c3f674fd911718fc3400e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab21cd7892b01ce7e5d2af53ecd973b8c65c711df6c3f674fd911718fc3400e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aab21cd7892b01ce7e5d2af53ecd973b8c65c711df6c3f674fd911718fc3400e"
    sha256 cellar: :any_skip_relocation, sonoma:        "783f4253c655c9ac68a6ce3e390f2c05a3f4f509a64d3db7713a84d31ff20cda"
    sha256 cellar: :any_skip_relocation, ventura:       "783f4253c655c9ac68a6ce3e390f2c05a3f4f509a64d3db7713a84d31ff20cda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac9af0c04324987bfba6a8bbe0df7a5fa21d19e3d226803ceacd7fc724acba4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9af0c04324987bfba6a8bbe0df7a5fa21d19e3d226803ceacd7fc724acba4b"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages"sipbuildbuilder.py", \bsys\.executable\b, "\"#{which(python3)}\""
  end

  test do
    (testpath"pyproject.toml").write <<~TOML
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    TOML

    (testpath"fib.sip").write <<~EOS
       Define the SIP wrapper to the (theoretical) fib library.

      %Module(name=fib, language="C")

      int fib_n(int n);
      %MethodCode
          if (a0 <= 0)
          {
              sipRes = 0;
          }
          else
          {
              int a = 0, b = 1, c, i;

              for (i = 2; i <= a0; i++)
              {
                  c = a + b;
                  a = b;
                  b = c;
              }

              sipRes = b;
          }
      %End
    EOS

    system bin"sip-install", "--target-dir", "."
  end
end