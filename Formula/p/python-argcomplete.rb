class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/c0/da/2565ca2ea7609388b49697653ef60c8588a61fa59346c56151c16e6ea0c6/argcomplete-3.1.6.tar.gz"
  sha256 "3b1f07d133332547a53c79437527c00be48cca3807b1d4ca5cab1b26313386a6"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22dd2c1b6e5e61c7c819cecb54d89e457f5c936859caaf738b755ec15cfcab25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb97b94c68fcf2db8ce0db387cb0cb10a14c1c9080b5258d511a92f6289df1ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cdbab13e1844a6c65c9897229b583fcbae515aef7006fa49ff2acbc5d2461d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b11e58a067d95dafe5b61cab890224a74e94a03b04812b983df5d3383c1980b6"
    sha256 cellar: :any_skip_relocation, ventura:        "db5227723f1f36e243a3279534f4cf9d8afeaae33d664b172cfa92b036fcf678"
    sha256 cellar: :any_skip_relocation, monterey:       "042cb233a610ec7b6a31ed085b21d2abb4aebdf6277fbb605c0ec466c31adb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90dabf10008c342ed060fc9a3d0605d8197a44134f246de7945e2593a3ddbfd8"
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