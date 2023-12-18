class PythonTermcolor < Formula
  desc "ANSI color formatting for output in terminal"
  homepage "https:github.comtermcolortermcolor"
  url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
  sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1f2906f6d0ddf24f3d43842c859910e1a619ab5e2946ed96a147f25b03db676"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bef20022d2caeafd1fe78aa6dbc3062b769fdd0ba51140c6de4c425d70c5bf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43fd6f9369571412d9deeb6a91c8058c484d89b832f6e172ed0575b347525073"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0d08d7eea557252aef9183df8048f20240298d73064fdfb747f8633056e73a7"
    sha256 cellar: :any_skip_relocation, ventura:        "2b8b63593bceba301d0dd591ce96e63d4c518ff6c31f6cfffc43264945c5a91b"
    sha256 cellar: :any_skip_relocation, monterey:       "0d824e070089ce681881489cba81efc7e4104d478d4a222b2bb825c8fa1e77bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d84763dc9f321a22046593c91a18912cd50d866fe1d8460f2dcc4f09561bb645"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
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
      system python_exe, "-c", "import termcolor"
    end
  end
end