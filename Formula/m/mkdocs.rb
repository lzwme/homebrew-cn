class Mkdocs < Formula
  include Language::Python::Virtualenv

  desc "Project documentation with Markdown"
  homepage "https:www.mkdocs.org"
  url "https:files.pythonhosted.orgpackagesedbb24a22f8154cf79b07b45da070633613837d6e59c7d870076f693b7b1c556mkdocs-1.5.3.tar.gz"
  sha256 "eb7c99214dcb945313ba30426c2451b735992c73c2e10838f76d09e39ff4d0e2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21c506ac04541d547779c7f0923c876fceceaf47672146165c0b643c9195c3f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "029c1fde63df91034bb74695a1544294956c21977813ae1f40b9224bdb105fe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2578725f7e7313cd6590082c81c4940cba39e66af6e0d7be69e6e4eb4f2e80d"
    sha256 cellar: :any_skip_relocation, sonoma:         "675abaea095bdf2163aa0eee8bfc1b776bcca49ae9d0ed81716e1de714fa39a3"
    sha256 cellar: :any_skip_relocation, ventura:        "d3d45a0e5bf2ff22321384f6f450389e35c6d1740764a15162ac53d13c6c1c67"
    sha256 cellar: :any_skip_relocation, monterey:       "a63af76c9ac1b3bd2596213e88f5f92d888b98e138d8a413342af03fe7330800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bccd16d5d1a932fe876095478b10d464cb766ccee9e78c1a6e6a4f262c21a2d"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-markdown"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "ghp-import" do
    url "https:files.pythonhosted.orgpackagesd929d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml-env-tag" do
    url "https:files.pythonhosted.orgpackagesfb8eda1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629cpyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "watchdog" do
    url "https:files.pythonhosted.orgpackages95a6d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ecwatchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  # Add missing setuptools dep
  patch do
    url "https:github.commkdocsmkdocscommitcc76672d5591b444e425423e41a0f5c0d42de9f8.patch?full_index=1"
    sha256 "7fdd3f760c25b9d08a4e97448fdb629a418913adc2d6222b2752719fe0ace60c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath"mkdocs.yml").write <<~EOS
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath"docs"
    (testpath"docsindex.md").write <<~EOS
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}mkdocs", "build", "--clean"
  end
end