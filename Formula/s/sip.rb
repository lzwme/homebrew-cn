class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d0/5f/d6dc58565d2d174064b545f8b3bef7b6117d25ee06181d5560cc290bd344/sip-6.15.0.tar.gz"
  sha256 "3920f26515456ee21114a1f8282144f8c156b1aabc3b44424155d5f81396025f"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2475b9243ead136b847da26877f0b403f2b05f56e5fdf48ac461470fd7b012cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2475b9243ead136b847da26877f0b403f2b05f56e5fdf48ac461470fd7b012cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2475b9243ead136b847da26877f0b403f2b05f56e5fdf48ac461470fd7b012cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "34e3958c8e2da261a7aa204845e6578b1bed4ba97cdaf3d90e18445cfbd0ebc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e3958c8e2da261a7aa204845e6578b1bed4ba97cdaf3d90e18445cfbd0ebc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e3958c8e2da261a7aa204845e6578b1bed4ba97cdaf3d90e18445cfbd0ebc0"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    (testpath/"pyproject.toml").write <<~TOML
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    TOML

    (testpath/"fib.sip").write <<~EOS
      // Define the SIP wrapper to the (theoretical) fib library.

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

    system bin/"sip-install", "--target-dir", "."
  end
end