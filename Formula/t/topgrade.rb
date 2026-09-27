class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.12.2.tar.gz"
  sha256 "9cffc162b7a4e0bc40379bc05eff44f62ce57c3ac13126b2d310068f138488ca"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "450f5ae202b361429babf6c212a73f144d9baf2cb8a5916c7b35a3ab9e230410"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e58422e0008d73b8e412c7a4985556876bb020ff610a13a82a9ed185cad70b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9cbcc3924259603b3d41a3ac3f218f86e8009349f0ef260111942972b270f51"
    sha256 cellar: :any,                 arm64_linux:       "91abde197b6f13705210984a52dad908c90a83f60729e2a274bce3bacaf45b53"
    sha256 cellar: :any,                 x86_64_linux:      "e18cb88696984600bf3034146ed9b569e5f83970b745da592d1047459c0bca09"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end