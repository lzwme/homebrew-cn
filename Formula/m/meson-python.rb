class MesonPython < Formula
  desc "Meson PEP 517 Python build backend"
  homepage "https://meson-python.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a2/3b/276b596824a0820987fdcc7721618453b4f9a8305fe20b611a00ac3f948e/meson_python-0.15.0.tar.gz"
  sha256 "fddb73eecd49e89c1c41c87937cd89c2d0b65a1c63ba28238681d4bd9484d26f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37c75fdb3518c8a4135277f559b2f07bb9412c1d716c021dc881788eedb1ff34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "169a4cb0f1bad11010bedb9f5e1e850ad6139a002adc4fdc817166be3e725171"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7ed3c4aaa02596a64ff81e61103430289e86dfb28a22bb779de97210244a80"
    sha256 cellar: :any_skip_relocation, sonoma:         "87c6d96b1853d619df476c79fd587ce1417dd88583284e1413841c03adbd770b"
    sha256 cellar: :any_skip_relocation, ventura:        "19f02d977f3c967333551e5dc530ad085718c9891c408df295da67e67cc7abd9"
    sha256 cellar: :any_skip_relocation, monterey:       "88d4388ebf27b9ca03580d365dd13fbba741d8bf4f65671b250a524c0c47e64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733bb899ea2139bab6a9b830304012b5ea78ab57fb096b460923c8eb867186b7"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "meson"
  depends_on "python-packaging"

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/38/af/b0e6a9eba989870fd26e10889446d1bec2e6d5be0a1bae2dc4dcda9ce199/pyproject-metadata-0.7.1.tar.gz"
    sha256 "0a94f18b108b9b21f3a26a3d541f056c34edcb17dc872a144a15618fed7aef67"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/site_packages
      python_exe = python.opt_libexec/"bin/python"

      resources.each do |r|
        r.stage do
          system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), Pathname.pwd
        end
      end

      system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), "."
      (prefix/site_packages/"homebrew-deps.pth").write libexec/"vendor"/site_packages
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import mesonpy"
    end
  end
end