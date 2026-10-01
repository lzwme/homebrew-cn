class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/a2/53/5eabf92b6057df00f97ab8f92a8463da4a934dffed57daf0897569be78e0/trash_cli-0.26.9.29.tar.gz"
  sha256 "2ca3300fd9f3b0334cb3f576a3ec95ced8593cc729df4332608d69a28eb50fb0"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a5eeae8398c0040d806067e2204ecb7e26530c456668879d25cd7368f8f6939"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20a5e685184748a046bf4e03689ca83a2dd31feaedbf6f5c6aa71e7f89bd5ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2b5d3c85c4f52775c4e8390158329f00529ccd1737bade3cf19d3ce1cd3e4da"
    sha256 cellar: :any,                 arm64_linux:       "c64f6f17bd30ece7bb3bf7c7f13cc1ff068a0aef992963307a09319d10fbd5be"
    sha256 cellar: :any,                 x86_64_linux:      "fb164eca5af4de10d5a3860a108ae92cd3c8aace8922d2c77d968979be9b2471"
  end

  keg_only :shadowed_by_macos

  depends_on "python@3.14"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_path_exists testpath/"testfile"
    system bin/"trash-put", "testfile"
    refute_path_exists testpath/"testfile"
  end
end