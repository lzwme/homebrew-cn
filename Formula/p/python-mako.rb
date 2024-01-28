class PythonMako < Formula
  desc "Fast templating language for Python"
  homepage "https://www.makotemplates.org/"
  url "https://files.pythonhosted.org/packages/a9/6e/6b41e654bbdcef90c6b9e7f280bf7cbd756dc2560ce76214f5cdbc4ddab5/Mako-1.3.0.tar.gz"
  sha256 "e3a9d388fd00e87043edbe8792f45880ac0114e9c4adc69f6e9bfb2c55e3b11b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a2f1c743d786f19d2c51b23bf40bbdbbac4398e0899c84d68d4772edf373ac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317af2f3882956e46fdfc696ed559e07acf7ca36f41fe785326b345245d862c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "262c2817219fa03b34e5456a364df57d84a41ab6c3f80639471e95890dd15402"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d22249c705c5395c0beedb3d2e15c0cf5f4a76e975fec09083fb172fec1aa86"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9a22535cddd472794bdd2601a7db8ea76245dff7cdce1c833bf0371384c416"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d0c1526cc5a56342786f119497ec25ff229f8a95bf836f567530e908ebcc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d5e7b60a46f37742fb488ca5a902f835a389e551c8818799760d6028b6b0b4"
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

  def caveats
    <<~EOS
      To run `mako-render`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from mako.template import Template"
    end

    (testpath/"test.mako").write <<~EOS
      Hello, ${name}!
    EOS
    output = shell_output("#{bin}/mako-render --var name=Homebrew test.mako")
    assert_equal "Hello, Homebrew!\n", output
  end
end