class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/d6/55/a26b19ff6245f6a84e45f9ff37f3a5d165222d81b8492fa79d34d22e14c6/translate-toolkit-3.10.1.tar.gz"
  sha256 "642e8597c55c3a31b8a6506194f0e64095965d5a1e7e0261d045a2865783a366"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a108f5a2fee67911f7acced4988bae63abed09e4cf90351e6ff3cdff308d98a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca1a5b90decf3bab90f3377fe43aad274a7b826bab21773587eff6836bd54369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "218167461583bb9f74709f26f71e5cb043f87a938769b2ddf18c2d31b3699652"
    sha256 cellar: :any_skip_relocation, sonoma:         "90f777cd67209c13cc66bba354b2cee96130e93a1acb1cf90f5f6486c09d094c"
    sha256 cellar: :any_skip_relocation, ventura:        "c806974a893956005c367a958f2c4bff0ac5943791b3c305e4881ee50eac93c4"
    sha256 cellar: :any_skip_relocation, monterey:       "1e49eef5a74e7e657b6ff05aff8d50ffd17b570060b706e9037e528212690ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b47538f8ca17e76d26c6ef45db890c4e2195721b8bac247e28aa6c94c2954ed1"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
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