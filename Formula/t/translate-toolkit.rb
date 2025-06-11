class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackagesc7c8ed119057675ea31eb255e7872a6150309447200545f8ec5f4888f8e50cd1translate_toolkit-3.15.3.tar.gz"
  sha256 "e25cbc54904feb3e81a8886b83c8dcc8c8e35c131a4df53ea6995b9842a47eab"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bf5bf713e37b81aa5d9da7a82738021b07092a3be4705b8e31a9134fe654167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "565cff2f17d812189f101b5baabcfa663e35b8c12d638db2213fdcb28946dc77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1b5f779cd6b3b98467789e4b5a7f3708e8c5f97c25932043e51bb9d9dbcbe5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26ab24b63f2719c2da6f1c64acff1ac75b5033c3516fde512fa67539767be0a"
    sha256 cellar: :any_skip_relocation, ventura:       "6674c9909bc9680ef4dc28c079ef25cd5d3155602724a612b300abb3efa460b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99eeb609bb1e383cd012e5f1abe8addb5a7bb4af22e285003a897bd1e5a8464e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af224abd20eb008156d635a8781aacfbffd41d4547c7d36afc0c10dca203a2b0"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https:files.pythonhosted.orgpackages237603fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
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