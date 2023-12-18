class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https:doitlive.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages025aec8769dc1c6f81939c0f7839b885f27b62b79b67fe69fcc67f347c0dd3ffdoitlive-4.4.0.tar.gz"
  sha256 "1b0031d6ce97778a292b247ccb762fda8212c1b935bc7da6a2be92f677a4ea60"
  license "MIT"
  head "https:github.comsloriadoitlive.git", branch: "dev"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66ebfcf68ad68439b5fbd0ebf5c882171de15777a70ca8a996e1269832ade953"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "849e69835f4cc63d1ef5469a9aef57440f2df15b1297db323818856be8f0e201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8aefdfca5b524bb22865302dfd3414eb6980e5ca7d4c695d93af8a56b0df9bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9f1f49bedcf932fc10b2605d0823fb1a7377d73a00a2bad924084ee68e06d27"
    sha256 cellar: :any_skip_relocation, ventura:        "c8981250f6fa705048df05f9a9c9ea6d20bcc1ff8798682314f75d25cd16d68f"
    sha256 cellar: :any_skip_relocation, monterey:       "e1323c6f6049b34d70e4f3fcc677ee0a6b94e8bd4b3ca37eb1bcc6fc0b8d08d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e4f232575f460cf2b6e1ac3064de7fb9434e2d8f8dc1c29bd680f8382994e0e"
  end

  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "six"

  resource "click-completion" do
    url "https:files.pythonhosted.orgpackages931874e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-didyoumean" do
    url "https:files.pythonhosted.orgpackages2fa7822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34fclick-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages74316d2297b76389dd1b542962063675eb19bb9225421f278d9241da0c672739shellingham-1.5.3.tar.gz"
    sha256 "cb4a6fec583535bc6da17b647dd2330cf7ef30239e05d547d99ae3705fd0f7f8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin"doitlive", "themes", "--preview"
  end
end