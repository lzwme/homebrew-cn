class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/cc/49/789313a50b9cf1f46389f38d90549269472093ea4f21aff9269c5ff0a41c/pyspelling-2.9.tar.gz"
  sha256 "df74c42e6e24171b7e1a83ac62fa2e151028ac045817c4f0384791c2d6099c5c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4955931444a37d184aa4333aa375ba80b3c705bcab1685cf9f59b7a5e472cd61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d8695b142445a11e36b3b88d1a9d9bfaefff0afcc687d8a9bcd528d2aa783ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef306133073366de18475fcee2bfc1e9276a50d8d32ddf1448da175b461607e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fb0caba189977a032fc4573462095e332fceeed462f5201b154b9a7df945234"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee5749e9ed26b61cd3a4b00caa57bcf5b5dff734fc543b7cf333dbcd17072cd"
    sha256 cellar: :any_skip_relocation, monterey:       "f737111a0e037983820b5e3e03f2231534df40780b738acc868586cacdbc36d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b121441818a29b1ed89b1e8c2b6d9ad2b50be5ee390f3e3ecd0212ab9be4f639"
  end

  depends_on "aspell" => :test
  depends_on "python-lxml"
  depends_on "python-markdown"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/92/51/72ce10501dbfe508808fd6a637d0a35d1b723a5e8c470f3d6e9458a4f415/wcmatch-8.5.tar.gz"
    sha256 "86c17572d0f75cbf3bcb1a18f3bf2f9e72b39a9c08c9b4a74e991e1882a8efb3"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath / "text.txt").write("Homebrew is my favourite package manager!")
    (testpath / "en-custom.txt").write("homebrew")
    (testpath / ".pyspelling.yml").write <<~EOS
      spellchecker: aspell
      matrix:
      - name: Python Source
        aspell:
          lang: en
          d: en_US
        dictionary:
          wordlists:
          - #{testpath}/en-custom.txt
        sources:
        - #{testpath}/text.txt
    EOS

    output = shell_output("#{bin}/pyspelling", 1)
    assert_match <<~EOS, output
      Misspelled words:
      <text> #{testpath}/text.txt
      --------------------------------------------------------------------------------
      favourite
      --------------------------------------------------------------------------------
    EOS
  end
end