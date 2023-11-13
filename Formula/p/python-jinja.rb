class PythonJinja < Formula
  desc "Fast, expressive, extensible templating engine for Python"
  homepage "https://palletsprojects.com/p/jinja/"
  url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
  sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afdf73cfe600bfc37e034a18594fe75160ddbb07140a7346a37d10dff5dda84f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13464ec67985d66fdccb5177f1c7de1d6da35f5cac38c317852c0de009fe6586"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5748e6caf4f6fefafac5139824e75504f82d4cfc775d8041478201a5771d2224"
    sha256 cellar: :any_skip_relocation, sonoma:         "60c05aaddd7e5220266d273cb36a6ff527853395e765d60f7fcdec621d8dd1ca"
    sha256 cellar: :any_skip_relocation, ventura:        "b8f20fb070c842a5fe7af82c1368355b5a95ee8e87ee5df3f672de530c465359"
    sha256 cellar: :any_skip_relocation, monterey:       "14de028b67099b3d9770c1d3f3d193866d7f1ad21219012e1c3e2517c725c9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f275df59683cc1e8d013e00dc24ed060f1a91a842908eab6c2bb18fff9e679"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-markupsafe"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from jinja2 import Environment"
    end
  end
end