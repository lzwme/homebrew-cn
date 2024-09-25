class OpenAdventure < Formula
  include Language::Python::Virtualenv

  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.20.tar.gz"
  sha256 "88166db3356da1a11d6c5b9faa0137f046e6eb761333c8d40cb3bcab9fa03e4a"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcde0baa9ffc69c4b261316334adf5ce27424e368904b92fbbec58bf12e27b19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24719a1b285532fd7d24928e613225dc731e5fe4e343f4d5175ad63f63829916"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c65f24202c7f159fb385dd9ba0b34c9eed5ef489c949ac6e9af721b75b71f1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a6832b75c19568b221b6318fbd1f8e0e03ac204412a63db5817fef554961a35"
    sha256 cellar: :any_skip_relocation, ventura:       "ad384419e8ab25a61ad668a5e74d75f16d0fdc051609de739ef174afd6d9833e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c39a99206825cf07171f76ae810ff97f53b70f5cbbbff9e5be8b9c0c5f827e"
  end

  depends_on "asciidoc" => :build
  depends_on "libyaml" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    venv = virtualenv_create(buildpath, "python3.12")
    venv.pip_install resources
    system venv.root/"bin/python", "./make_dungeon.py"
    system "make"
    bin.install "advent"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end