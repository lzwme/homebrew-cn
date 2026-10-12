class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://files.pythonhosted.org/packages/99/f7/86a84bfdc32c0b3d3fafe90a299a131d2aa661b57cab3d14a506f42405db/internetarchive-5.11.1.tar.gz"
  sha256 "2ae0a529ffe4195c5294a0277e0a9afb83fc00fee5695c6597f65c64e95da44a"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://github.com/jjjake/internetarchive.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "483fb4dc129e19e0304a77c04b6ebdae0d355c658b5d78bf5239947d383fe240"
  end

  depends_on "certifi"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/2c/29/8f7262f848569fe374b34a0f09e6d366bdd5ac82081edbecd5fd104fe9fc/jsonpatch-1.34.tar.gz"
    sha256 "e60c9f2d903d261d6eddcbd12cf3193efdb58cd9376a36ccc4db2e29d6cc88e3"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/5a/30/76a208d3eb75a5e2bcfec4e132c207ea1e22253d10b52a06c8ff3839dfc9/jsonpointer-3.2.0.tar.gz"
    sha256 "807db557622fbe07a0d49e19cf4795a269d55eee5ba345fb9959d148eba5ef94"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    metadata = JSON.parse shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end