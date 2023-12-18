class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https:github.commiracle2ktarsnapper"
  url "https:files.pythonhosted.orgpackages4ec50a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fetarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b48aef71d275be4e640ed1f99dea73050cee3600f0745f5bbc9c99b36454957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2f9c0a3797364ca219a20d6200ad6f0005c81ba6010e572f300ef39ec31b68a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9abbdd4147588aec9a0b33a804e8d672494330c14d6ec0e6e6a78fded43c25e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d324865fef97a462dd0ca212179902e6f713da22769fb76477c0b8bd3d68314f"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6d4a1fcf598f49d227d4921f844a80e0c22edf374a758b5a1981be24a2b838"
    sha256 cellar: :any_skip_relocation, monterey:       "12ef312292edb578e80d80f1ac2e7eaaad5ec1ddb446eda4a5e9dff8569be8bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e788ef51a4b7de45dcb87de4d509fe22852339b4257fa2946fb48113b01defc"
  end

  depends_on "python-dateutil"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "tarsnap"

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackagese59bff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}tarsnapper --help")
  end
end