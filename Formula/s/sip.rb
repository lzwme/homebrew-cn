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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1647ecca1bd34681c703ab8b81456498c4fdef70027d41140d5ec4fd6e151fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e73168681a89130c5b5efc6b71a24401c2bcbb926e3977f72d299dedbd67bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f73f58cbbcc03e333028bbb5755f9d0c86ecbfc347deaf629ca9627adfc4b96"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e05f10af54fa696800a2617bad7d593892480a94ce88c6dd3ea646490d79850"
    sha256 cellar: :any_skip_relocation, ventura:        "b86b65f828679343b923e979fe521938a1cd4e34b1063d05e1430d11f5094e39"
    sha256 cellar: :any_skip_relocation, monterey:       "28255dc1f579e00c48139785a4446c6541d6ec0b88caa42a68f4c4a556becd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7986f4a1ce3adb36adaa847ade2dd209ddccfb478803404fbff28cac74e2d311"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-ply"
  depends_on "python-setuptools"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
  end

  def install
    clis = %w[sip-build sip-distinfo sip-install sip-module sip-sdist sip-wheel]

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      clis.each do |cli|
        bin.install bin/cli => "#{cli}-#{pyversion}"
      end

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      clis.each do |cli|
        bin.install_symlink "#{cli}-#{pyversion}" => cli
      end
    end
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

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      system "#{bin}/sip-install-#{pyversion}", "--target-dir", "."
    end
  end
end