class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/c0/da/2565ca2ea7609388b49697653ef60c8588a61fa59346c56151c16e6ea0c6/argcomplete-3.1.6.tar.gz"
  sha256 "3b1f07d133332547a53c79437527c00be48cca3807b1d4ca5cab1b26313386a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8d4c6a34f724a2219f5f39ec630871fa8d67f19af35a159130ff5f0fd2d026d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "735cfa954219a3f535a469302a2719c8adbb4f80ce2222aad374811bf3f1a70b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be19c9d6811b50c5dbf9ae2fc614c577859a44f2c14c8ee5ec19fcb6051caf4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f11d6efd2ec59c751c8ff79626fcce59275e3606360d36dd591315d32c51a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "631cfbf6b640ecc5e6f739d758c006d4394c52e3144a2851154805b4109aa4b2"
    sha256 cellar: :any_skip_relocation, monterey:       "761a73c9cef599c2a1e191fb0869ef01a16f57a4d084ff23cf1a691f77bd5635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e8c44299fb28636d550631fed3a78e2a88f0fcecd734b86a76c996a3523e591"
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