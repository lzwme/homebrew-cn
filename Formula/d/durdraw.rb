class Durdraw < Formula
  include Language::Python::Virtualenv

  desc "Versatile ASCII and ANSI Art text editor for drawing in the terminal"
  homepage "https://durdraw.org"
  url "https://ghfast.top/https://github.com/cmang/durdraw/archive/refs/tags/0.31.0.tar.gz"
  sha256 "992801c677d0bef72ee84404ccf73667036a8de2ea72ad3c38f27729bada2173"
  license "BSD-3-Clause"
  head "https://github.com/cmang/durdraw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5421a097e2ed1982d23a11d41154648565137ad8e0fb083b53844c25b5807a57"
  end

  depends_on "ansilove" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "python@3.15"

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