class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/bc/ca/877e9b50c0092e6a9df860901309d9ec70e7dd0b077ee9bedc8bab24bb7f/trove-classifiers-2023.11.14.tar.gz"
  sha256 "64b5e78305a5de347f2cd7ec8c12d704a3ef0cb85cc10c0ca5f73488d1c201f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7016e9426e20bd3db5a49c88b029cc1bca563ee359bbf164e01431f9614517cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8daf59ea6e45d06470947009c0f766f2fdf5756103edd689aff6969b7c18f498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d6fff32d2902aea767fd97854df97ce3106359eb2d3af3356823f96048f2eff"
    sha256 cellar: :any_skip_relocation, sonoma:         "8963768683a1200d83933c457a843762f1041d5a7739388a797a43a9c73d5cdd"
    sha256 cellar: :any_skip_relocation, ventura:        "14ab5dff1893f598c3860e176518cdb438bbfff6c507cb4cb676d3fe8f1d3fc1"
    sha256 cellar: :any_skip_relocation, monterey:       "58470c775c1315f163dc138af3a411ba589f7d05c2fce04b743dbd28c11e804f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ac52d30c480705d9fdcec931bae393dfd68c5bef062a09ac80bd4ddb83b979"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end