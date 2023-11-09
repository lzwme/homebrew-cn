class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e8/e1/ff890eed6a5dc5e2b28aee259cf6f93ff8ac3aff8d0e25874109e1b3255c/translate-toolkit-3.11.0.tar.gz"
  sha256 "aa91e5d1901e93bf3495279fe7165ef283eade2feb798a9fe00231bdc2ec5b2a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a15bede1a9391d4c9c007d827221316c1f26b9880f28597fd47b0b85c1cb8774"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f0f1f73b740aff82baee165a41612ad6b0a09534fcdf38c0752b0a3ed7c29d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7174c4f2cb7370fce138113e68b80fbcc0bcac9bc0d9e8be584450dabb36d14c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f51f4e2820795f201941e7c20836528ffb6cf4b8b7f69b879828b9609ad2fc0"
    sha256 cellar: :any_skip_relocation, ventura:        "955bd6cbd673a3fc558354fc42fb311f44e0eeb13b4b29ed9b1696a461a8b85b"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9933ac340b3481696b49e8f2793e50bff752e3ab227f2953867688890b3471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa2142db7a1a5ffa0f9a23e0b8b3a684adbc623d4e00f3f56de454f21584464"
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