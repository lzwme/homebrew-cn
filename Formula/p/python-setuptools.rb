class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/86/ff/f75651350db3cf2ef767371307eb163f3cc1ac03e16fdf3ac347607f7edb/setuptools-80.10.1.tar.gz"
  sha256 "bf2e513eb8144c3298a3bd28ab1a5edb739131ec5c22e045ff93cd7f5319703a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4eb1cfad054aa8c4a7148bf8a09e940389d5b86575087d4416eab746041d941f"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.12" => :test # keep on oldest python to support (externally managed and not EOL)

  def pythons
    deps.filter_map { |dep| dep.to_formula if dep.name.start_with?("python@") }
  end

  def install
    odie "Need exactly 2 python dependencies!" if pythons.count != 2
    oldest_python, python = pythons.sort_by(&:version)
    python_exe = python.opt_libexec/"bin/python"
    system python_exe, "-m", "pip", "install", *std_pip_args, "."

    # Pure python setuptools installation can be used on different Python versions
    site_packages = prefix/Language::Python.site_packages(python_exe)
    python.versioned_formulae.each do |extra_python|
      next if extra_python.version < oldest_python.version

      # Cannot use Python.site_packages as that requires formula to be installed
      extra_site_packages = lib/"python#{extra_python.version.major_minor}/site-packages"
      site_packages.find do |path|
        next unless path.file?

        target = extra_site_packages/path.relative_path_from(site_packages)
        target.dirname.install_symlink path
      end
    end

    # Ensure uniform bottles
    setuptools_site_packages = site_packages/"setuptools"
    inreplace_files = %W[
      #{setuptools_site_packages}/_distutils/compilers/C/unix.py
      #{setuptools_site_packages}/_vendor/platformdirs/unix.py
    ] + setuptools_site_packages.glob("_vendor/platformdirs-*dist-info/METADATA")
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", "import setuptools"
    end
  end
end