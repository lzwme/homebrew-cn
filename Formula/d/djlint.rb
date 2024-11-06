class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https:djlint.com"
  url "https:files.pythonhosted.orgpackagesb16045f31c057ed7957aa28fadca9e9575c89273c785de774b6a8cae3d1cc4b5djlint-1.36.0.tar.gz"
  sha256 "c6a16905d69d02bfd745084a3ebf065707efbaf0a31762b34441802beb206b51"
  license "GPL-3.0-or-later"
  head "https:github.comdjlintdjLint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40725ba70889326c76ab3c88ddcff26dd804d8853e9d1a268452a46a8a08695c"
    sha256 cellar: :any,                 arm64_sonoma:  "d0dd6f2358464ec14de61c13e1b075a048a933c85f64acbb9102bc4a0d1e3187"
    sha256 cellar: :any,                 arm64_ventura: "eedb191ca2f56dbc377f64ecbf42c6b226da3db35a0664b2dc7b9ee8504b2665"
    sha256 cellar: :any,                 sonoma:        "73688cd73df2d17a94990ef7de571f899046ac1434deb128b949199e69273897"
    sha256 cellar: :any,                 ventura:       "691dc9af1b862d327f16e3c397f82e03ffa4b4b1bae9633bf88b668a856f7c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8610c9a3b389b2691e83e5c8974cbd49f10c40f8dae175dd682c3f2e88fd7ddc"
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