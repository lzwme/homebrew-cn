class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/72/34/65d7891ea2c1232155bc0ccc5fac6db0d1baba184e17b494148bd42cc1a2/sip-6.8.0.tar.gz"
  sha256 "2ed1904820cb661b7207eb1dccfaebec1a5463dcad903ba448ad1945502d089c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40f1cd829319617077117cb9dde2f8337b8eef848171a31135255f1db13b424d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a8cf21d261af79d4bffd3566e5965b590ab8183cc00e74875a4d3ef8ad60451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84759d5795579e172dc97a943b62c9468e6921a426a616209a3225e9de9fe005"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dca3b4f6168c08913fbb79e5bfc145514f80ea3becccad7a2a1a601470417d1"
    sha256 cellar: :any_skip_relocation, ventura:        "94c947382742bd691b9f06250bd0ba989e0e19336e062e768ff35c660ad006a2"
    sha256 cellar: :any_skip_relocation, monterey:       "53780c928e4773cb200566fad6117454705d671cacaf925654d6b556ef9ba4c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "930bb015bccb73c1081844d5e78ea80f95e0f185dd6217060e0f3cfacbcfdebd"
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