class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https:beancount.github.io"
  url "https:files.pythonhosted.orgpackagesbb0d4bfa4e10c1dac42a8cf4bf43a7867b32b7779ff44272639b765a04b8553ebeancount-3.0.0.tar.gz"
  sha256 "cf6686869c7ea3eefc094ee13ed866bf5f7a2bb0c61e4d4f5df3e35f846cffdf"
  license "GPL-2.0-only"
  head "https:github.combeancountbeancount.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220fca5da217c97fb5a9fad7ca6915bc55c9bae1d79fbdad5ee965442077d3d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09220a93a40eaa115f24d4e39e9e0f74aefaf36a973a42a56b7f23ab9af1f8f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcc06911282b28ad7c6f77c9b846eda048d22c90d09ebc353734273b0e9c0e5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "904439e31cf5362140019d4bc222f5ece05c5421fbcfb6d1123732be6cf8e445"
    sha256 cellar: :any_skip_relocation, ventura:       "3c2df16ce54d376f303adae8bf2aea116c294b884f7e4661b73fe4dd9ab80619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9af264b6a0e9e5862107f3eb0d162ad92ce914f96e452f3efbf31e790c6e9b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources

    bin.glob("bean-*") do |executable|
      generate_completions_from_executable(executable, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    (testpath"example.ledger").write shell_output("#{bin}bean-example").strip
    assert_empty shell_output("#{bin}bean-check #{testpath}example.ledger").strip
  end
end