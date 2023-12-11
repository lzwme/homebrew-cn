class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/b8/a0/524e0aaabf9bc3dfcfb4da4c61a0469d5cbac31e39dd807a832ea6098c91/argcomplete-3.2.1.tar.gz"
  sha256 "437f67fb9b058da5a090df505ef9be0297c4883993f3f56cb186ff087778cfb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "209b7b16053b21c5de8433b927b00e65e70984c367bde20d153c0546b28330e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "625e2a43b9ba4beaa97feca972fbe08967a9412821356de114e7b4745e103579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e55043d13bda4e3b1ba2ed0f30830d2d585bff395066809ebbaeb8c0e2823fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "51ba924fcbb35149ee0df76589540abfdc6ddcbd4050e72952b4f63faacc4339"
    sha256 cellar: :any_skip_relocation, ventura:        "c79684eb35fafa2ef25067af9cfed7b1ac73fb30138a5efa47cd2d7cb19bb005"
    sha256 cellar: :any_skip_relocation, monterey:       "e1100e4c821a6bd28e1a6d92c8f602527b266d6ed21be13e61f9c2c1afa1990d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78ce327cee59132015580b74cd231f0fa9d6bb259e9ad9355c4b02a021296ad"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
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

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
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