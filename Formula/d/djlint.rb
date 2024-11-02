class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https:djlint.com"
  url "https:files.pythonhosted.orgpackages874b78205d41de135f8c36515f8b015a2e923492926576fe7ca76abb3aee8027djlint-1.35.4.tar.gz"
  sha256 "d4a1342d83e65171059925b87ab351a1d5201289a764f9e092ef7a99e312554e"
  license "GPL-3.0-or-later"
  head "https:github.comdjlintdjLint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "680f963515cac34d79aab75d76ebdec2b554ed6b3609504a9319cfae3a7fb16d"
    sha256 cellar: :any,                 arm64_sonoma:  "b84209233ec157af8ba4f3e63088488f844a196df18a739ca209486ed14f3f0e"
    sha256 cellar: :any,                 arm64_ventura: "ba84d6e214e3d63778f6760d8193a1517a71692cc5f63110bc0a3667ec546222"
    sha256 cellar: :any,                 sonoma:        "43b30632978f6b129e4f361213239ba78e360936da1d8d7aec63acb0f4f615de"
    sha256 cellar: :any,                 ventura:       "acc5409db9486ef069c496b78a56e7441d142c0a61c6a6e85e6e272c61a3ffb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fba28b2f12e37deda1f10b233a00c8d2795030f184f00e7486f60c76ba9f093"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssbeautifier" do
    url "https:files.pythonhosted.orgpackagese5669bfd2d69fb4479d38439076132a620972939f7949015563dce5e61d29a8bcssbeautifier-1.15.1.tar.gz"
    sha256 "9f7064362aedd559c55eeecf6b6bed65e05f33488dcbe39044f0403c26e1c006"
  end

  resource "editorconfig" do
    url "https:files.pythonhosted.orgpackages3d857b5c2fac7fdc37d959fab714b13b9acb75884490dcc0e8b1dc5e64105084EditorConfig-0.12.4.tar.gz"
    sha256 "24857fa1793917dd9ccf0c7810a07e05404ce9b823521c7dce22a4fb5d125f80"
  end

  resource "html-tag-names" do
    url "https:files.pythonhosted.orgpackages417c8c0dc3c5650036127fb4629d31cadf6cbdd57e21a77f9793fa8b2c8a3241html-tag-names-0.1.2.tar.gz"
    sha256 "04924aca48770f36b5a41c27e4d917062507be05118acb0ba869c97389084297"
  end

  resource "html-void-elements" do
    url "https:files.pythonhosted.orgpackages805c5f17d77256bf78ca98647517fadee50575e75d812daa01352c31d89d5bf2html-void-elements-0.1.0.tar.gz"
    sha256 "931b88f84cd606fee0b582c28fcd00e41d7149421fb673e1e1abd2f0c4f231f0"
  end

  resource "jsbeautifier" do
    url "https:files.pythonhosted.orgpackages693edd37e1a7223247e3ef94714abf572415b89c4e121c4af48e9e4c392e2ca0jsbeautifier-1.15.1.tar.gz"
    sha256 "ebd733b560704c602d744eafc839db60a1ee9326e30a2a80c4adb8718adc1b24"
  end

  resource "json5" do
    url "https:files.pythonhosted.orgpackages915951b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbcjson5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagese934bef135b27fe1864993a5284ad001157ee9b5538e859ac90f5b0e8cc8c9ectqdm-4.66.6.tar.gz"
    sha256 "4bdd694238bef1485ce839d67967ab50af8f9272aab687c0d7702a01da0be090"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_includes shell_output("#{bin}djlint --version"), version.to_s

    (testpath"test.html").write <<~EOS
      {% load static %}<!DOCTYPE html>
    EOS

    assert_includes shell_output("#{bin}djlint --reformat #{testpath}test.html", 1), "1 file was updated."
  end
end