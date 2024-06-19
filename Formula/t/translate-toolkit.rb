class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackagesc48fe703d7eb64e54b0b9f5cc4f9af6798a987acd70daf920097e1146161fdd8translate_toolkit-3.13.1.tar.gz"
  sha256 "4f1e56668dc01fb0967d8c6fee11984869353f849036c4b1a130db64eaf26730"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30e68022e0e11186167be58861c8c4acf7e683e12d3f2e0e10cdf5c77d8f52f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04b4d47a48f37e8ddc622ad09d8a1093ad6991c459bd959012141c8048e96445"
    sha256 cellar: :any,                 arm64_monterey: "ba632b3b5836c299f74f8291e2539418aff1bd136baa5c6316e777edae46313a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9be544a529e8bc432f061d597dc07de5c3f24e4d31f18d51bdb03334ab74738b"
    sha256 cellar: :any_skip_relocation, ventura:        "242b310c5dfd0827e25f143a53b1b0a30b631fcbf029fb08b0917b59cd2ec98f"
    sha256 cellar: :any,                 monterey:       "85752ca47102361639ffbde46af2ac67f31e58753b0b4e713c39d5dfff2bf992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e9f1023920f5b634460d0f62584c118cbf7fdcbe9e1073fd514d095fd2839d"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}podebug --version")
  end
end