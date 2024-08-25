class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https:github.comjtestassh-audit"
  url "https:files.pythonhosted.orgpackagesf1265b724f1ade0a40aeea41cf39e7db497209a97b947b48acf378bf7630fa87ssh_audit-3.2.0.tar.gz"
  sha256 "ebbad6b5e9e0ad930e8d2d7034f890605a461ad52bf7021a09fd9edf17945e31"
  license "MIT"
  head "https:github.comjtestassh-audit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "81e991deab1a3f781204c1999da94562f5108b142ecae92d35bad997a39c9874"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}ssh-audit -nt 0 ssh.github.com", 1)
    assert_match "[exception] cannot connect to ssh.github.com port 22", output

    assert_match "ssh-audit v#{version}", shell_output("#{bin}ssh-audit -h")
  end
end