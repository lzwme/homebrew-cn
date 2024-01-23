class PythonMako < Formula
  desc "Fast templating language for Python"
  homepage "https://www.makotemplates.org/"
  url "https://files.pythonhosted.org/packages/9c/cf/947dfd8475332b603dc8cb46170a7c333415f6ff1b161896ee76b4358435/Mako-1.3.1.tar.gz"
  sha256 "baee30b9c61718e093130298e678abed0dbfa1b411fcc4c1ab4df87cd631a0f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ea40271cbbbc129e4dd4aa3c53bd20451ef819f51b34346d6de96b0cb6d3851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5683bfbb8fa8cebe8f8284c0cbef6dcc3ff85ee87568a4dcaec27da4c294bb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e084b5fc2c45931ac31c63c40044b317363ec782611e85a68cd6b4a70cf23831"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0a5efd66e129d805e341550e1bbf48261155c67b91c6252556fb54a3f2a93d0"
    sha256 cellar: :any_skip_relocation, ventura:        "8978b3e38cb87e26b46a70440666436c0423b8a9673580922a5652da53071b7c"
    sha256 cellar: :any_skip_relocation, monterey:       "a17d14be18196a2187b0b1367a608cd54eea29e4477e1cf20ffe04e0c4fb9274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a765af59ae3cb78ae8d6bb1f87ea85620a316977c6df33db0407d5f74ddb7b7"
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