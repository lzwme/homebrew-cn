class AdrViewer < Formula
  include Language::Python::Virtualenv

  desc "Generate easy-to-read web pages for your Architecture Decision Records"
  homepage "https:github.commrwilsonadr-viewer"
  url "https:files.pythonhosted.orgpackages1b720f787da38d0f9d69c06b31d8f412735ed4fad383edd7f7d2286f4fc7b5b0adr_viewer-1.4.0.tar.gz"
  sha256 "9a2f02a9feb3a6d03d055dd8599b20d34126f8e755b4b4ee1a353ecbbd590cef"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fff66558a3dc0891dc960355f0f0525f80e9c06aa98e23f3aeac43dadcc5288c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d7214417dfde8e74de0c67bf102a01ba39130c7a36b6980011b48f1b16839d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84f2ad61fb54d99fa10d6f09284046748dbace538a4766c655a8015083fa90f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7d1b41c9e9f9c69157d4a5a7128e75fc724c41e7e55b9da434483afe026518"
    sha256 cellar: :any_skip_relocation, ventura:       "b717a63b17499a157bf65ef88fb3ad874a455e27595d81bd1530bb6b158ba6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "926f71bbc769190aa84277149755a9cba09fdb10f81a6930b60b7249481cd5c9"
  end

  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackages1bfb97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "bs4" do
    url "https:files.pythonhosted.orgpackagesc9aa4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mistune" do
    url "https:files.pythonhosted.orgpackagesefc8f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    adr_dir = testpath"doc""adr"
    mkdir_p adr_dir
    (adr_dir"0001-record.md").write <<~MARKDOWN
      # 1. Record architecture decisions
      Date: 2018-09-02
      ## Status
      Accepted
      ## Context
      We need to record the architectural decisions made on this project.
      ## Decision
      We will use Architecture Decision Records, as [described by Michael Nygard](https:thinkrelevance.comblog20111115documenting-architecture-decisions).
      ## Consequences
      See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https:github.comnpryceadr-tools).
    MARKDOWN
    system bin"adr-viewer", "--adr-path", adr_dir, "--output", "index.html"
    assert_predicate testpath"index.html", :exist?
  end
end