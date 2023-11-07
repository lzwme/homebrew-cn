class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/47/98/87dfab0ae5d1abad48a56825585dcd406cdc183dbce930e24ef8439769ba/mackup-0.8.40.tar.gz"
  sha256 "d267c38719679d4bd162d7f0d0743a51b4da98a5d454d3ec7bb2f3f22e6cadaf"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c68eab85cbed5c2269b4ba470184a53b7f1d27f01cd4fe08736b0f8ae030126"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0e8a8cfef053a5d238fe4e109fa499956d76ecc32942eaf3a84329016a0d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bef9c324a26d5f93ce0d480db47fb1675288a2ce84e06132d11eff6fdfa3d5a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d0a18af86164067cacea62b13f4cb0856ba1e238e6b00174f4e492073daea71"
    sha256 cellar: :any_skip_relocation, ventura:        "fe2304bfe5b7a82524d4c1df7c3f70fe6b0632a7320148e379dcc5bce671b16c"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7fdca1f9621ee3534ca7c6979bf84e84709b9720e1544f30f02587c5b297f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c818c7735d3347dbc2419b604aeaebcae7a93e7acd036cbb4222b051668ab70d"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end