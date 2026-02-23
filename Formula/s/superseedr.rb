class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "03d47c6e37e00491ef263879f8023104f2f0025ec3cac8fbc0f887f853f4ad67"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16f9e755e87ed41d14060cb5895ec3d11d2a2d70b270762f3df22322f911571a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be611c99d41f891639c056fa997b4e6194b0d62e1bbdd612e3695913482b2ade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04566f4987fa8f25e998cd04c90f2f97b63ce3f9a011446ffebd7248cc0c75c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "37bdf98e2de003966503922c37be17297e0a5811893d892c2da29233cc515411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbc7cfae5432989863bf8150b55dbd69eb1bb8692e490b041411b7ec1b8c3819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd6b28e8b04d68223aa2940d09b455243ef1ec9fb090dee3a75bb607aeaee43"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end