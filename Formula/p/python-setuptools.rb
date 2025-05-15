class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/2b/22/2e66d286bf92bc5f0d0822346e53fc856b5e6ad38b2a53bcde7ea5eb1299/setuptools-80.7.0.tar.gz"
  sha256 "d3b6ba519cc2b1e0b14195ef1a9560f675b1f873dc0d42969e139b2b58e763d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cefcf342dfc86dce721535b5639e94d33888bb935bd670f7d3f03ec46f292c19"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    inreplace_paths = %w[
      _distutils/compilers/C/unix.py
      _vendor/platformdirs/unix.py
    ]

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."

      # Ensure uniform bottles
      setuptools_site_packages = prefix/Language::Python.site_packages(python)/"setuptools"
      inreplace setuptools_site_packages/"_vendor/platformdirs/macos.py", "/opt/homebrew", HOMEBREW_PREFIX

      inreplace_files = inreplace_paths.map { |file| setuptools_site_packages/file }
      inreplace_files += setuptools_site_packages.glob("_vendor/platformdirs-*dist-info/METADATA")
      inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end