class Durdraw < Formula
  include Language::Python::Virtualenv

  desc "Versatile ASCII and ANSI Art text editor for drawing in the terminal"
  homepage "https://durdraw.org"
  url "https://ghfast.top/https://github.com/cmang/durdraw/archive/refs/tags/0.30.0.tar.gz"
  sha256 "ea91651c6c44cc0bb322d120f32c9f5a7f36536fdbe71274637df3eaf65af57a"
  license "BSD-3-Clause"
  head "https://github.com/cmang/durdraw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6010866852f923ced1f0c00031afba6aaa8eafe6f03125ab129c52993c1070d4"
  end

  depends_on "ansilove" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources

    %w[durdraw.1 durfetch.1 durview.1].each do |file|
      man1.install file
    end

    pkgetc.install "durdraw.ini"
    pkgetc.install "themes"
  end

  def caveats
    <<~EOS
      Default configuration and themes are installed to #{pkgetc}
    EOS
  end

  test do
    # Durdraw is a TUI application
    assert_match version.to_s, shell_output("#{bin}/durdraw --version")
  end
end