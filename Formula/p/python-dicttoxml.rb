class PythonDicttoxml < Formula
  desc "Converts a Python dictionary or other native data type into a valid XML string"
  homepage "https:github.comquandyfactorydicttoxml"
  url "https:files.pythonhosted.orgpackageseec93132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5dicttoxml-1.7.16.tar.gz"
  sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dac85fda41d9ab1cd1cd699de46bbf8079868bf2cbbea416d537f21e5ae81dd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0d1c1c129ecfef946e84eba970080225b7532a98e2b872e782f7835751feef6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5a88993c838f1071cd10aa82fe7f3300e55f04bcb7b12e11b762638cb662235"
    sha256 cellar: :any_skip_relocation, sonoma:         "6448ac827e77266f9c24963c898aeb6d0d04e14b8f8d1b7540969f0f29fd0649"
    sha256 cellar: :any_skip_relocation, ventura:        "62871d5de79323be5020897fc05b304a260712badbe61906689f22d4318e24b6"
    sha256 cellar: :any_skip_relocation, monterey:       "8807803e3c2e248ac2e63fb0a68aff09d45435eacfe2bb3494ed35e315a59d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2247af90e3c52d8145381f3cdde4cff94341c77ab5519f99ad6da5c6bffe0ab7"
  end

  depends_on "python-setuptools" => :build
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
      system python_exe, "-c", "import dicttoxml"
    end
  end
end