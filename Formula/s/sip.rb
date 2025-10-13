class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/a0/c725bf92945a95e6aee2a07f26f7f33ee2720a06bdd06b2e5692075bd761/sip-6.13.1.tar.gz"
  sha256 "d065b74eca996f29f1f0831ad321efaecf9906759b09466edc45349df7be6cd0"
  license "BSD-2-Clause"
  head "https://github.com/Python-SIP/sip.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81d0c98f5ea41d1639847181abcaa834d9226f3322936944df0028cfc1a9e67a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81d0c98f5ea41d1639847181abcaa834d9226f3322936944df0028cfc1a9e67a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d0c98f5ea41d1639847181abcaa834d9226f3322936944df0028cfc1a9e67a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad7638698802f279f90f11d21bbb329182db750f589b583b98f213d80cf67f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ad7638698802f279f90f11d21bbb329182db750f589b583b98f213d80cf67f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad7638698802f279f90f11d21bbb329182db750f589b583b98f213d80cf67f3"
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