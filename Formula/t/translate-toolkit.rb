class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/2d/96/02265cf887313ca433d177ea4b1153826cf167c78a1456a5919c20eafd1c/translate-toolkit-3.11.1.tar.gz"
  sha256 "eb88f9874e622536774de9d40da3105d8aecdd2c114f18faadb3116e9d59c610"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0df102bb89437257b0ae7e30e1ca62d9f5beb77b5f1b6addf1d1865876135fe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98d39d7e9eed86fa3e14b2bee85ee2d23ea191f902c1ff52442d0f0da14e73b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8935fb6c2f9e93fad21032c63abc0de23259fb2b0c938044b100bba4221e0c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd3161b99010e3d86a0744bfc5847b98bcdfadaf06446d6c2e27d86cb8a510ef"
    sha256 cellar: :any_skip_relocation, ventura:        "4d04bcbe655b6fcb21240f11af44946ed0756fc36f55406410395056d91d510b"
    sha256 cellar: :any_skip_relocation, monterey:       "c7c925507ad24af71384ec298215f2b7989d77a21e92214443f7cfb19ac6915f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02eb6369b34ed3594fec6a51f887768d7a59d59b2f91bbc22e71f84b03fd41d1"
  end

  depends_on "python-lxml"
  depends_on "python@3.12"

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