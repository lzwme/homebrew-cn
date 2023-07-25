class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/50/3a/ae9b9e36c7f1db92675b25f722ff7a8c3f6efd50817d5c946a7637dacd88/sip-6.7.10.tar.gz"
  sha256 "398aeb84ee03f3a953947cac70e60d3b02dceba3c4f4dd46c5383e9dbe3936bb"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "127bf4229369ddb1b9a6cc641739c6bad37b868dfbb274c64000672500f34ffc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f72a9d4ba398556bc8ecdf12d6802decdb0e87403929c2b667b5e2a1464e59c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d9352ac90bf804afc09a0933ab4a243569160d26809ced8cd19812817c67ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "c5f3b4aa08612a340f03a80146d8b0fd065c837ff3346cb8253c9d8dcae9ee1b"
    sha256 cellar: :any_skip_relocation, monterey:       "21f8ccfa0a185aaf888beb7a21f5587270bcb910c4634f8133a6f8d2dad02787"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d04de7805781ed5f505ed13502e6ede2fb2de33f6d349074682200c2ec4b035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2a1ee1f1f8818a760ca6523a4b29dbf5f30d973f572501d6f9a2bd3998e6fc1"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    # We don't install into venv as sip-install writes the sys.executable in scripts
    system python3, *Language::Python.setup_install_args(prefix, python3)

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-sip.pth").write pth_contents
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    EOS

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

    system "#{bin}/sip-install", "--target-dir", "."
  end
end