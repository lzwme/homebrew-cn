class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https:github.comkellyjonbraziljello"
  url "https:files.pythonhosted.orgpackagesfb5efe41641ce367cb8b57a6514372fffd7aed4a8c916cd7dc0bb7e9ae8f6ae2jello-1.6.1.tar.gz"
  sha256 "eee1d43f2d9bb3b3b8c857b713e56191badb9a03a2274defaad1e727fad35521"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6aee2f309a909d8f46313936879821ecd4dfbef13d3a1c75732fee794eb941b4"
  end

  depends_on "python@3.13"

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    virtualenv_install_with_resources
    man1.install "manjello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}jello _.foo", "{\"foo\":1}")
  end
end