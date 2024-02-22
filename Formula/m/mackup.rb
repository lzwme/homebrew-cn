class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https:github.comlramackup"
  url "https:files.pythonhosted.orgpackages479887dfab0ae5d1abad48a56825585dcd406cdc183dbce930e24ef8439769bamackup-0.8.40.tar.gz"
  sha256 "d267c38719679d4bd162d7f0d0743a51b4da98a5d454d3ec7bb2f3f22e6cadaf"
  license "GPL-3.0-or-later"
  head "https:github.comlramackup.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e22ea66e97029c577384ba1b1bc6e1658fe1888073d94c48d69106134d81f868"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3dd122a9074c7cebe47c225d1403baac544ce5a8b15b7dad7b17024dd6d8261"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98b5d8843db7055612ff403c4d0b2d0b99bc91bd7d19886a4dbe7e52c80bc187"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd566741bc14216b9290ff9b91d6a4532c0f3c198663bbddb76c9ea51c084b96"
    sha256 cellar: :any_skip_relocation, ventura:        "21fcd593cb776efdc50b2194c61d0977102dba05a09a0ea95061074b32048372"
    sha256 cellar: :any_skip_relocation, monterey:       "8df2bac26e01ef277c9a0cf8c4b2b970ecda3c01a5ab1a0b5ece8573b930c56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14ca4c39200be37ff9284f29ba9d3cefa5a2385407fcb24818d456e9eae03080"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}mackup", "--help"
  end
end