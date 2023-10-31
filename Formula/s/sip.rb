class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/a6/4e/c34eee70109e9a8110672f074fc18b5022bf4b9b4c92641245c73ae0b21a/sip-6.7.12.tar.gz"
  sha256 "08e66f742592eb818ac8fda4173e2ed64c9f2d40b70bee11db1c499127d98450"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81472454e0a9781c11164d85829d24cb3f1ccf566e5847c3fa6ea16c625ebcf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecdfcc705f6ea39477af3d873323945efa3afea01353612ebc5d4e06bf8269e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29ed4515ddf4fb7e292adcadd77b9f52542bf0a810c8f9778d33b66a0b40dbd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "18563470e033c08b78893b7977fb72185037d1adbe6575c2c455d238efcc75a6"
    sha256 cellar: :any_skip_relocation, ventura:        "63f6de9fc50b7bfdbad254a98af5b1141203d8714d85b5826f9bb593940e5099"
    sha256 cellar: :any_skip_relocation, monterey:       "3bbf56702657317a6ea5391d9da408d4eed0641b0bdf6f19b2ce649ec556e474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1792c730d4be1cf5c126a116a4c15601fa40594b971e5aaadd93752e38e7988f"
  end

  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    # We don't install into venv as sip-install writes the sys.executable in scripts
    system python3, "-m", "pip", "install", *std_pip_args, "."

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