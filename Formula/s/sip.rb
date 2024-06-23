class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https:python-sip.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages3ef585bfb3c716b8eda9e2b0c0c5f36acb701746045c828a4497a44e581db3a6sip-6.8.5.tar.gz"
  sha256 "5dddd5966e9875d89ecde9d3e6ac63225f9972e4d25c09e20fa22f1819409c70"
  license "BSD-2-Clause"
  head "https:github.comPython-SIPsip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4efa47c9d2d33bf5897fe994aef25905611c59d3d80db8f8591aadfee43bdb4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4efa47c9d2d33bf5897fe994aef25905611c59d3d80db8f8591aadfee43bdb4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4efa47c9d2d33bf5897fe994aef25905611c59d3d80db8f8591aadfee43bdb4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0838e9d57c425db439eef5bde3707c0b7ddc09e4f222a6e8f0f3e5a519b0339"
    sha256 cellar: :any_skip_relocation, ventura:        "f0838e9d57c425db439eef5bde3707c0b7ddc09e4f222a6e8f0f3e5a519b0339"
    sha256 cellar: :any_skip_relocation, monterey:       "f0838e9d57c425db439eef5bde3707c0b7ddc09e4f222a6e8f0f3e5a519b0339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11c3e5fffd8754227f3c8938e0cebcc6b30d17d80a99abb22fa909055b851463"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages1c1c8a56622f2fc9ebb0df743373ef1a96c8e20410350d12f44ef03c588318c3setuptools-70.1.0.tar.gz"
    sha256 "01a1e793faa5bd89abc851fa15d0a0db26f160890c7102cd8dce643e886b47f5"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages"sipbuildbuilder.py", \bsys\.executable\b, "\"#{which(python3)}\""
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    EOS

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

    system "#{bin}sip-install", "--target-dir", "."
  end
end