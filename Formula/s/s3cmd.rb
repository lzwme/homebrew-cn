class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https:s3tools.orgs3cmd"
  url "https:files.pythonhosted.orgpackagesb39cad4cd51328bd7a058bfda6739bc061c63ee3531ad2fbc6e672518a1eed01s3cmd-2.4.0.tar.gz"
  sha256 "6b567521be1c151323f2059c8feec85ded96b6f184ff80535837fea33798b40b"
  license "GPL-2.0-or-later"
  head "https:github.coms3toolss3cmd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f50c604d84cc73c3c9e94aa5547a206fb7edae7a35e66dc0555d92908711366e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a229f62e50fc7d9fb539a01483042fb7a88648003334be457ac06624370cb14e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22680b45454ec9c0e43d7abb26a42d574a5ea06d7840babdf79765b781056a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "720658e76b053b6fd8df4409514bbb205d17efa207a228478b4960e87159b4c7"
    sha256 cellar: :any_skip_relocation, ventura:        "9d891ad94c9c4a2011f67cfc51d72853093a2dd9ef2ed54357621d50025bd82f"
    sha256 cellar: :any_skip_relocation, monterey:       "386f6632fdc692e06d8112acdd22b0515a356be00b67c8f8cdf2b64cdbdb29f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4f12dc89cd23c016da42400c079a6ed78597fa6314e6db3ae398e811b922bd"
  end

  depends_on "python@3.12"

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    assert_match ".s3cfg: None", shell_output("#{bin}s3cmd ls s3:brewtest 2>&1", 78)
    assert_match "s3cmd version #{version}", shell_output("#{bin}s3cmd --version")
  end
end