class PythonWcwidth < Formula
  desc "Measures the displayed width of unicode strings in a terminal"
  homepage "https://wcwidth.readthedocs.io/en/latest/index.html"
  url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
  sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "394094bd8fd6cc90897694b27fb3dd06a33028a21e310e7ec1b25f1e9656ba42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87390af94aea19fcaef00228f624c16df3b23121f5c6e763bda5175c1ba5c1a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8079ddb87c418ce5878fbd15de794ea7b4aeaa6fd8bb462cadaec19e847535d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a73044626f24fa1194ea6a91c3f72ddf173795b8025169bc2f5b0abda7b32224"
    sha256 cellar: :any_skip_relocation, ventura:        "cce0c057851d2a2fe04dbb852424bc2f38ab937ba1fa74d0be55e6847f605c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "fef02060db6eecc5ba59534210f9206696e9c5a518dcfb1544dc6a2434d85a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "530b89f841153f0e6a6f0a5f2d81d684f75ca05fb2b81d6ea91915f45bfcc94b"
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
      system python_exe, "-c", "from wcwidth import wcswidth"
    end
  end
end