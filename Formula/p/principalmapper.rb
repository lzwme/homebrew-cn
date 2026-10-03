class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/3f/8c/3d2efe475e9244bd45e3a776ea8207f34a9bb15caaa02f6c95e473b2ada2/principalmapper-1.1.5.tar.gz"
  sha256 "04cb9dcff0cc512df4714b3c4ea63a261001f271f95c8a453b2805290c57bbc2"
  license "AGPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8f9f3b1d9ca8294abab9e32ece80b4fd2186484079384d0eb2d6cf0ee970bd5"
  end

  depends_on "python@3.14"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/11/b9/10ca68d0092895d5ea60f485a61a9840d5aff9d732c66ed60da53a20b1d4/botocore-1.43.106.tar.gz"
    sha256 "006870b3b4e40547232ad12c3bb4faec91bbbe0659aafaa3b7fa48a112c4ee97"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/50/35/b17cb89ff865484c6a20ef46bf9d95a5f07328292578de0b295f4a6beec2/pydot-4.0.1.tar.gz"
    sha256 "c2148f681c4a33e08bf0e26a9e5f8e4099a82e0e2a068098f32ce86577364ad5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/nccgroup/PMapper/commit/88bad89bd84a20a264165514363e52a84d39e8d7.patch?full_index=1"
    sha256 "9c731e2613095ea5098eda7141ae854fceec3fc8477a7a7e3202ed6c751e68dc"
    type :backport
    resolves "https://github.com/nccgroup/PMapper/issues/106"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end