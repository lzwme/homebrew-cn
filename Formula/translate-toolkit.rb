class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/5f/24/11587aa98f03fc076f205714245c630d1bab1e7f83e911c32827b9461d8e/translate-toolkit-3.8.4.tar.gz"
  sha256 "f5ce4f301be38c1f388bf6e50beadb3d0219185105d1a5d023a982d66801f55e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c87a43e7f6193ac2e6453c9993002b5f1811ef3e2d10d68eebac0906b060a5f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "722e932ec86c14fe281956f57f96588f15d162a7b7a7689cbed6fd1cd92e43a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73ababe321125b2daae97576011e4aa6c0e295913ff11ce7b5f07eb058661e72"
    sha256 cellar: :any_skip_relocation, ventura:        "819e3cc82046f4adf5a3da9a1f237fc8840da8658162105a9e60052329695a99"
    sha256 cellar: :any_skip_relocation, monterey:       "9752417c08de11f086f984512be9bbcec1ba9e87bdd3acab63088e38db3ffdef"
    sha256 cellar: :any_skip_relocation, big_sur:        "edbf295ac8214d0a6374d4fe42b3309f748d6bcf851edf28338ab20101527d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90178de6ee920536503d79f71d9a0036d8c9f155098e28e147af108af7a3e06c"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end