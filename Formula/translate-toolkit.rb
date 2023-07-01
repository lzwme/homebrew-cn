class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/1b/b6/8552b915b1bf2f0e08b96cbbecd4a78c1b4a62d9c473785c11e24abde83e/translate-toolkit-3.9.2.tar.gz"
  sha256 "cd0430f061b135e46ec5eec9350fa8a7745d337826a90f5b6ac2c3b1b0123476"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5518fbf403a865cb3465094aea94f3f32b21ad37795c123c03b1156fc7c37d8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d775b18f181ea4c03225bb1f21c66edfe5b70b44a7514d6723b034e1d25b279d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bd945ecba2965d7569a93f46114b87770a7b91f0d5c510389241a5a33a5e549"
    sha256 cellar: :any_skip_relocation, ventura:        "25abcfebdc151967803c1ff3d2187ea867a12949d96b54a6f65643460728c507"
    sha256 cellar: :any_skip_relocation, monterey:       "39f296bdffe523d16aa96f02f3941e43cce18a74dfd320074956cdca78d18aea"
    sha256 cellar: :any_skip_relocation, big_sur:        "59ea66a0716c74e54146647a2e6b9bb81b163f1afa802e3049129e7e34f10e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0239ac8ffe3121b5cc28fe05fa9d99f2ff6501cb77b76cb1e0d645ec4bd6d8"
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