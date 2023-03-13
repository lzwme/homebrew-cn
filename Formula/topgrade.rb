class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghproxy.com/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.3.2.tar.gz"
  sha256 "4522d82e46ecf36891b0b2750a06c535bbf59a86794b00e2a5cc3f5ef961d644"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "918007858ec4d43b6f33281f5bfcd6ea31f08533d0d56d55ce581b94a471c60b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ae7a33a0db2552e89b5170669f14f576ec8aa740f9ec4619f05be91ca6cb502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43dc498c8d720814fa7967c146aa3511df153aa550bb7fa559362a91c1fb2251"
    sha256 cellar: :any_skip_relocation, ventura:        "82fd8bac8380f9971864d78b02579f0fa6c90c6a2b6427c57afbe7680cb6f0e7"
    sha256 cellar: :any_skip_relocation, monterey:       "71234d8338e82556446aa4509d7fe9aa047e9a468a186a6b5410745dab8001d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bb27f49795d353268851c8829d9deb2ab2ea4daa9def062a1503aba096c46a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa536599322aa0c83bbacb2dcb0dbfdbb986b9cadccfcbdd5dddd8286487f26f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end