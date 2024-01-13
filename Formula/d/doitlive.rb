class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https:doitlive.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages2f03d7c78453bb5831f7ec1a40e1acb85b950a32399f85917650b4e5eada39d6doitlive-5.0.0.tar.gz"
  sha256 "8c0a226eccc3a5026388d0990e15f77cb9e200b386eebf58a9a604c9292630ce"
  license "MIT"
  revision 1
  head "https:github.comsloriadoitlive.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56fe514b5aa4b447c05c849ccd890e9bc8d7727887f8a34d2eafa4995b1dda5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a64d223d6fcdc83a8d511c8d66b0fb0d402d3f145e4bbd97a2d27d8b60e93c97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2f548a29fa98ba95d0d198986e57d7f9dbd2d6402ae8de82c3feb5ba9f71f00"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef9b13c1170ab8ee8d35515abe76e630e9a3d304e829874f138e48985d353504"
    sha256 cellar: :any_skip_relocation, ventura:        "7937ae9bb34b23b52a7d15ad344b6b3436cea0ca58cdfe892747b0225af9eb36"
    sha256 cellar: :any_skip_relocation, monterey:       "9ada66a04d3a84fc073be7ae638217cb3764220cf098e7540ad2e12ef8388977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1d777ba9fd13cd5cc416912576c8dc7ccb8eb80f90963844b1aee8ec2efa14"
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
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
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