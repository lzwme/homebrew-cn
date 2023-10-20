class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
  sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfda93727397ae34cdfc34a8cb2b589dd45859330fe747eac056a3e8156ac4e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abddebc5027f9113b74b85bfe98002f2c5a1e23ed8591baa9929a79731879df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "515e29a3276468695d603cd72a52f2b312a723a1488f4f928907ec8b31f09bb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bc571d7e1db858b53652511e48141ce301d9e05b560d1a7834fb97e347e4d20"
    sha256 cellar: :any_skip_relocation, ventura:        "e2894ca5fa9e799bbbd7bb52b7e5e1321a1c5f66f7500786189b4b6a5487f390"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0e773b68464a8972506ba245763e3344ecfc3d60d0e19d078d0e741f29ed46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d837e1e916680d71e2f453315dea5c0798b1adfd2b469f0e70ad94734faeae"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import packaging"
    end
  end
end