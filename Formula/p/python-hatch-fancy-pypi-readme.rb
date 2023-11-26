class PythonHatchFancyPypiReadme < Formula
  desc "Fancy PyPI READMEs with Hatch"
  homepage "https://github.com/hynek/hatch-fancy-pypi-readme"
  url "https://files.pythonhosted.org/packages/85/a6/58d585eba4321bf2e7a4d1ed2af141c99d88c1afa4b751926be160f09325/hatch_fancy_pypi_readme-23.1.0.tar.gz"
  sha256 "b1df44063094af1e8248ceacd47a92c9cf313d6b9823bf66af8a927c3960287d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4697468bfb7171cea5e7a6047fa6852882b704cc82a2ad70c4a0dd79ff893a55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a34810e1207bf8c38eda110f66c4d5b9b07717673e1916bba6253ed13eb5d97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c987096a84770d8456abb423c3ff62292621b1d3e705fa30f48401216a27c8d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e8c68f39db2b2c5b95efb0b8113f1ea20c03627b6dbdc707b1d2248b3a08178"
    sha256 cellar: :any_skip_relocation, ventura:        "8bebaa85dbd55e254e697f7365a9d962536a421e3e98a73288e496b1ea2f89bb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d68c0e41ffee4cc1daaf20d492d981a0dae7fa698a47525d5ab1bff5d01696d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b807619868dbceef3076769c5ff39fc42ad37e325710f89be83e1f59029741"
  end

  depends_on "python-hatchling" => [:build, :test]
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

  def caveats
    <<~EOS
      To run `hatch-fancy-pypi-readme`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["hatchling", "hatch-fancy-pypi-readme"]
      build-backend = "hatchling.build"

      [project]
      dynamic = ["readme"]

      [tool.hatch.metadata.hooks.fancy-pypi-readme]
      content-type = "text/markdown"

      [[tool.hatch.metadata.hooks.fancy-pypi-readme.fragments]]
      text = "Fragment #1"

      [[tool.hatch.metadata.hooks.fancy-pypi-readme.fragments]]
      text = "Fragment #2"
    END

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatch_fancy_pypi_readme"

      output = shell_output("#{bin}/hatch-fancy-pypi-readme --hatch-toml pyproject.toml")
      assert_match "Fragment #1Fragment #2", output
    end
  end
end