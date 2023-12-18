class PythonPluggy < Formula
  desc "Minimalist production ready plugin system"
  homepage "https:github.compytest-devpluggy"
  url "https:files.pythonhosted.orgpackages365104defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40pluggy-1.3.0.tar.gz"
  sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87883f5160fe791dfdd6624355c5fdaf4305ca967ec1245f45568f633e98d5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "376b3bf5c729e596e2f8f96655283b25aa21dbf82c2b53bdc6c4a9957d333bf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13af6d795edf1c545f4a6e510b7a3017ba2f743ad2bf3f43c7134871dad09c72"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7eb87b3ffce68228dfe49fa02b79a0a83716e294895fd72d9851b365733b0da"
    sha256 cellar: :any_skip_relocation, ventura:        "7d418f4a267357b80566f8f100fbc7b2f7882fcb53a6a0b47b75b3942dfde7de"
    sha256 cellar: :any_skip_relocation, monterey:       "8c7f6d0d4ed4e73b10cf34308833013d90a1ffd225441a85a99bd369afa8d0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1150011c67539979561ec4d34a7ec9c2e26af1aedb2656c0eb267781da82aaf5"
  end

  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "import pluggy"
    end
  end
end