class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https:pypi.orgprojectbumpversion"
  # maintained fork for the project
  # Ongoing maintenance discussion for the project, https:github.comc4urselfbump2versionissues86
  url "https:files.pythonhosted.orgpackages292a688aca6eeebfe8941235be53f4da780c6edee05dbbea5d7abaa3aab6fad2bump2version-1.0.1.tar.gz"
  sha256 "762cb2bfad61f4ec8e2bdf452c7c267416f8c70dd9ecb1653fd0bbb01fa936e6"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "166ec2e234ca2b7970dac12809f1eb9642c8647cd030169049b866c7d03f19ee"
  end

  # Original and fork are both unmaintained:
  # https:github.comperitusbumpversioncommitcc3c8cfd77380ef50eeac740efe627509a248101
  # https:github.comc4urselfbump2versioncommitc3a1995b35335da6fa7932e4bac089992c947bba
  deprecate! date: "2024-09-08", because: :unmaintained, replacement_formula: "bump-my-version"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["COLUMNS"] = "80"
    command = if OS.mac?
      "script -q devnull #{bin}bumpversion --help"
    else
      "script -q devnull -c \"#{bin}bumpversion --help\""
    end
    assert_includes shell_output(command), "bumpversion: v#{version}"

    version_file = testpath"VERSION"
    version_file.write "0.0.0"
    system bin"bumpversion", "--current-version", "0.0.0", "minor", version_file
    assert_match "0.1.0", version_file.read
    system bin"bumpversion", "--current-version", "0.1.0", "patch", version_file
    assert_match "0.1.1", version_file.read
    system bin"bumpversion", "--current-version", "0.1.1", "major", version_file
    assert_match "1.0.0", version_file.read
  end
end