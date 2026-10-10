class Pycparser < Formula
  desc "C parser in Python"
  homepage "https://github.com/eliben/pycparser"
  url "https://files.pythonhosted.org/packages/ac/d3/eb1d3bc30dda12f7e69640ae2ac8cb10240b71fb73024ad528b7d2ae73da/pycparser-3.1.tar.gz"
  sha256 "b3fc6dec06a8b2fefa0ed4ff92285306a5e3be9987bc5603c9edbdc4e492418f"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c008a84b1a89712d6f194b5e3dfd8ed76f08b5ecb2d197571dd8445ae2bf2955"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]

  deny_network_access!

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
    pkgshare.install "examples"

    # Pure python installation can be used on different Python versions
    # Add symlinks to use on all externally-managed pythons
    extra_pythons = Keg.for(python3).to_formula.versioned_formulae.select { |f| f.version >= "3.12" }
    extra_site_packages_list = extra_pythons.map { |f| lib/"python#{f.version.major_minor}/site-packages" }
    extra_site_packages_list << (lib/"python#{Formula["python-freethreading"].version.major_minor}t/site-packages")
    site_packages = prefix/Language::Python.site_packages(python3)
    site_packages.find.select(&:file?).each do |path|
      extra_site_packages_list.each do |extra_site_packages|
        (extra_site_packages/path.relative_path_from(site_packages)).dirname.install_symlink path
      end
    end
  end

  test do
    examples = pkgshare/"examples"
    system python3, examples/"c-to-c.py", examples/"c_files/basic.c"

    # Check that the wheel is safe to use on all pythons
    wheel = prefix/Language::Python.site_packages(python3)/"pycparser-#{version}.dist-info/WHEEL"
    assert_match(/^Tag: py3-none-any$/, wheel.read)
  end
end