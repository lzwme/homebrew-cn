class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/48/28/2a56c0fccc0bb07bd369bbb2b2a1452743f84acb08145eaccc11b3e6fa74/argcomplete-3.1.4.tar.gz"
  sha256 "72558ba729e4c468572609817226fb0a6e7e9a0a7d477b882be168c0b4a62b94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c0c67a7dbbc3ded7befcf3fcb40d48dcb598b41a8f9846ea37843df15dc14fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdfac1b9c7ba20a6cea80f1c4d2db07d3168373fbf3ded75fb12038c0805f11d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23f80acde047710ab6092a2ab793a7077b81d90f8c2fc30ea068d0b30ba6dc99"
    sha256 cellar: :any_skip_relocation, sonoma:         "86f10733dcdbf91f6a111dda4d67bec78c239865400ae50e1e99fece904f0a7c"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec719705faac565d64de853a1cb85efa6454afb77b3dd6a60fd280cacd1f651"
    sha256 cellar: :any_skip_relocation, monterey:       "24b9967a29b6bffe839295a45dd67e9ac31e5924b498d300fefc9a14f46ca0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97dcbd7b97633b3c701c5d15bf184022189163296a31deede3365c88e495aff6"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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

    bash_completion.install "argcomplete/bash_completion.d/_python-argcomplete" => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end