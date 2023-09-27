class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/f2/b9/88c7f0ecba0a8fbf07e0d7674b7eac3dbf5270ac39a3b48bc34bb7c5a22c/ssh-audit-3.0.0.tar.gz"
  sha256 "a6a9f94f6f718b56961b70dbf1efcc0e42b3441822e1ea7b0c043fce1f749072"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07ca3ad26792c0eccd135ee1b787266779d59eb7b9c3ed338e9d96931fb8a05f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb4fd261558f1fb8f307cea851bdbdecdb6295a63d1691bd11842103abfd01d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6668313ad849f96455062174f3162d348a6d09d6468e50bc4dc9e8b0f4e6cae5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e296c8b437dc7e428b7da859d148bd41be3eb78f8a5b1f6cb754c8b583f0468a"
    sha256 cellar: :any_skip_relocation, sonoma:         "135a6e0b060394058afdf1bd4f7b4672e7d86335c60d7aa728056db5760f80cc"
    sha256 cellar: :any_skip_relocation, ventura:        "d03c6cfd9412cf6dd4eb2a2117e2ebc355bcf714eee37c9b123232ef51c35310"
    sha256 cellar: :any_skip_relocation, monterey:       "432ba13cea83291598afdfd4d7b9b29e403c681ea840447dd19d06989f331fc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d862c06ac3f070241f6a58bf69e6dec5e532c63ad5912223aa138bab551d9dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "883a310a7ea3133c68213aca91d8589153bc0a525854a6ef087250e3baf8f7ef"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end