class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https:doitlive.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages2f03d7c78453bb5831f7ec1a40e1acb85b950a32399f85917650b4e5eada39d6doitlive-5.0.0.tar.gz"
  sha256 "8c0a226eccc3a5026388d0990e15f77cb9e200b386eebf58a9a604c9292630ce"
  license "MIT"
  head "https:github.comsloriadoitlive.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f1ec95117c2da5ad4fa32c5a6c3289c46ea026732c64198425ef0923c454247"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fb582e4fdefbba9afd80be2d8288c15ae918585b248b72067a9d8a7f568a038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5820d32a643f8a9ee10b854819ce3ec94ee99fff0a3090433073cb1bd3ea0b03"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0738a3b78a21cac717ad78ff5df3261116ef221f562a65f789882ffe0893fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "2a2f2f3969c1c820659e655c91903cad2741efb13624ddd9587d0434b6c2e3d3"
    sha256 cellar: :any_skip_relocation, monterey:       "29a91d446a2fb98b291cc9d9f769be8cbdb35b94fc50a4227b2f89bd90d09b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f0d28adffa7469b691c0a37542a673c01a34ab9eb906ff4c0706fdc9e6f6bd"
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
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin"doitlive", "themes", "--preview"
  end
end