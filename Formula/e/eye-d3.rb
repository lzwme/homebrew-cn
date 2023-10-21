class EyeD3 < Formula
  include Language::Python::Virtualenv

  desc "Work with ID3 metadata in .mp3 files"
  homepage "https://eyed3.nicfit.net/"
  url "https://eyed3.nicfit.net/releases/eyeD3-0.9.6.tar.gz"
  mirror "https://files.pythonhosted.org/packages/fb/f2/27b42a10b5668df27ce87aa22407e5115af7fce9b1d68f09a6d26c3874ec/eyeD3-0.9.6.tar.gz"
  sha256 "4b5064ec0fb3999294cca0020d4a27ffe4f29149e8292fdf7b2de9b9cabb7518"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/nicfit/eyeD3.git"
    strategy :github_latest
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23a97c427e8d7e027dd215230dfdb0a9843bf4b21479c93b6d1ccca222736898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b3a304bb9dca1443b0b1887c8f1e992a092a80feb0cc0b3c282fb27fe597c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "badf2521f1510f4b97b53244abddf59a1970945e23cd09e1c434648ba412b803"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8e4de4305386934bc1aff000d36933497efde4f6fa22ac74761d892dca067c9"
    sha256 cellar: :any_skip_relocation, ventura:        "ca47a023d45212cb841b6be5011adcc43aeda8b73726f682b1aec2d5fb21db46"
    sha256 cellar: :any_skip_relocation, monterey:       "0524f02d98210b845fd5108fad85bb11e68efa7373df85759a53a4d2327fd0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b660e9c9f8d5a5e257ed6edf34f3ab5869e4b53cb4943c60bb23b59f7ed3360"
  end

  depends_on "python-packaging"
  depends_on "python-toml"
  depends_on "python@3.12"

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/38/df/d5e67851e83948def768d7fb1a0fd373665b20f56ff63ed220c6cd16cb11/coverage-5.5.tar.gz"
    sha256 "ebe78fe9a0e874362175b02371bdfbee64d8edc42a044253ddf4ee7d3c15212c"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # https://github.com/nicfit/eyeD3/pull/589
  patch do
    url "https://github.com/nicfit/eyeD3/commit/2632963eca6d84481d133fcac496434dad72e38f.patch?full_index=1"
    sha256 "6b4e7bf8b6b282b1eeab65c80c499934677357e1fa3ce21d4009bfc719b07969"
  end

  def install
    virtualenv_install_with_resources
    share.install Dir["docs/*"]
  end

  test do
    touch "temp.mp3"
    system bin/"eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end